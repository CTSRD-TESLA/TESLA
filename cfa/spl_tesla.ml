(*
 * Copyright (c) 2011 Anil Madhavapeddy <anil@recoil.org>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 *)

open Printf
open Spl_syntaxtree
open Spl_cfg
open Spl_utils
open Spl_utils.Printer

type env = {
    statenum: (id, int) Hashtbl.t; (* Map state names to integers *)
    mutable scnum: string array; (* Map statecalls to integers *)
    statecalls: (id, string list) Hashtbl.t; (* Statecall name, functions which use it *)
    funcs: (string, (Spl_cfg.env * func)) Hashtbl.t;
    debug: bool;
    sname: string;
}

let rec reduce_expr sym ex =
    let rec fn = function
    | Statecall _ | Struct _ -> assert false
    | And (a,b) -> And ((fn a), (fn b))
    | Or (a,b) -> Or ((fn a), (fn b))
    | Not a -> Not (fn a)
    | Greater (a,b) -> Greater ((fn a), (fn b))
    | Greater_or_equal (a,b) -> Greater_or_equal ((fn a), (fn b))
    | Less (a,b) -> Less ((fn a), (fn b))
    | Less_or_equal (a,b) -> Less_or_equal ((fn a), (fn b))
    | Equals (a,b) -> Equals ((fn a), (fn b))
    | Plus (a,b) -> Plus ((fn a), (fn b))
    | Minus (a,b) -> Minus ((fn a), (fn b))
    | Multiply (a,b) -> Multiply ((fn a), (fn b))
    | Divide (a,b) -> Divide ((fn a), (fn b))
    | Int_constant a as x -> x
    | True -> True | False -> False
    | Identifier i ->
        try 
          let ex = List.assoc i sym in
          let sym = List.remove_assoc i sym in
          reduce_expr sym ex
        with Not_found -> Identifier i
    in Spl_optimiser.fold (fn ex)

(* Convert expression to a string *)
let rec ocaml_string_of_expr ?reduce ex =
    let rec fn = function
    | Statecall _ | Struct _ -> assert false
    | And (a,b) -> sprintf "(%s && %s)" 
        (fn a) (fn b)
    | Or (a,b) -> sprintf "(%s || %s)" 
        (fn a) (fn b)
    | Identifier i -> 
        (match reduce with None -> i | Some fn -> fn i)
    | Not e -> sprintf "(!%s)" (fn e)
    | Greater (a,b) -> sprintf "(%s > %s)"
        (fn a) (fn b)
    | Less (a,b) -> sprintf "(%s < %s)" 
        (fn a) (fn b)
    | Greater_or_equal (a,b) -> sprintf "(%s >= %s)" 
        (fn a) (fn b)
    | Less_or_equal (a,b) -> sprintf "(%s <= %s)"  
        (fn a) (fn b)
    | Equals (a,b) -> sprintf "(%s = %s)" 
        (fn a) (fn b)
    | Plus (a,b) -> sprintf "(%s + %s)" 
        (fn a) (fn b)
    | Minus (a,b) -> sprintf "(%s - %s)" 
        (fn a) (fn b)
    | Multiply (a,b) -> sprintf "(%s * %s)"
        (fn a) (fn b)
    | Divide (a,b) -> sprintf "(%s / %s)"
        (fn a) (fn b)
    | Int_constant a -> sprintf "%d" a
    | True -> "1"
    | False -> "0"
    in
    fn ex
    
let ocaml_type_of_arg = function
    | Integer x -> (x, "u_int",false)
    | Boolean x -> (x, "u_short",false)
    | Unknown _ | Extern _ -> failwith "type checker invariant failure"

let initial_value_of_arg = function
    | Integer x -> sprintf "%s = 0" x
    | Boolean x -> sprintf "%s = false" x
    | Unknown _ | Extern _ -> failwith "type checker invariant failure"

let ocaml_format_of_arg = function
    | Integer x -> (x, "%d")
    | Boolean x -> (x, "%B")
    | Unknown _ | Extern _ -> failwith "type checker invariant failure"

(* Run an iterator over only automata functions *)
let export_fun_iter fn genv =
    Hashtbl.iter (fun fname (env, func) ->
        if func.export then fn fname env func
    ) genv.funcs

(* Run a map over only automata functions *)
let export_fun_map fn env =
    Hashtbl.fold (fun fname (env, func) a ->
        if func.export then (fn fname env func) :: a else a
    ) env.funcs []

(* Pretty-print a state struct *)
let pp_record_type e genv env tname t =
  (* calculate number of bits needed for an int *)
  let num_bits v =
    let v = ref (v-1) in
    let bits = ref 0 in
    while !v > 0 do
      incr bits;
      v := !v lsr 1
    done;
    !bits in
  let total_width = ref 0 in
  e.p (sprintf "struct %s {" tname);
  indent_fn e (fun e ->
    let max_state = Hashtbl.fold (fun _ num a -> max num a) env.statenum (-1) in
    e.p (sprintf "u_int state : %d;" (num_bits (max_state+1)));
    total_width := num_bits max_state;
    List.iter (fun (nm,ty,m) ->
      let range = try num_bits (Hashtbl.find genv.reg_ranges nm)
        with Not_found -> 32 in
      total_width := !total_width + range;
      e.p (sprintf "%s %s : %d;" ty nm range)
    ) t;
  );
  e.p "} __attribute__((__packed__));";
  e.nl ();
  let uname = String.uppercase tname in
  e.p (sprintf "#define %s_PTR(tip) ((unsigned char *)((tip)->ti_state))" uname);
  e.p (sprintf "#define %s_STATE(tip,off) ((struct %s *)(%s_PTR(tip)+(off)+1))"
    uname tname uname);
  e.p (sprintf "#define %s_NUM_STATES(tip) (%s_PTR(tip)[0])" uname uname);
  (* For current Tesla, just assume >8 bits for a state is bad *)
  if !total_width > 32 then
    failwith (sprintf "Total width of %s > 8 bits (==%d)" tname !total_width);
  e.nl ()

let pp_env genv env e =
  let comment xs = 
    e.p "/*";
    List.iter (fun x -> e.p (sprintf " * %s" x)) xs;
    e.p " */" in
  comment [ sprintf "This file is autogenerated by the Tesla CFA compiler";
    (sprintf "via: %s" (String.concat " " (Array.to_list (Sys.argv))))] ;
  e.nl ();
  List.iter e.p genv.includes;
  e.nl ();
  e.p "#include <sys/types.h>";
  e.nl ();
  e.p "#ifdef _KERNEL";
  e.p "#include <sys/systm.h>";
  e.p "#else";
  e.p "#include <assert.h>";
  e.p "#include <stdlib.h>";
  e.p "#include <stdint.h>";
  e.p "#include <string.h>";
  e.p "#endif";
  e.nl ();
  e.p "#include <tesla/tesla_state.h>";
  e.p "#include <tesla/tesla_util.h>";
  e.nl ();
  e.p (sprintf "#include \"%s_defs.h\"" env.sname);
  e.nl ();
  let num_of_state s = Hashtbl.find env.statenum s in
  export_fun_iter (fun func_name func_env func_def ->
    let uname = String.uppercase func_name in
    let block_list = blocks_of_function func_env env.funcs in
    let registers = list_of_registers func_env in
    pp_record_type e genv env func_name (List.map ocaml_type_of_arg registers);
    e.p "void";
    e.p (sprintf "%s_automata_init(struct tesla_instance *tip) {" env.sname);
    indent_fn e (fun e ->
      let ist = initial_state_of_env func_env in
      e.p (sprintf "%s_NUM_STATES(tip) = 1;" uname);
      e.p (sprintf "%s_STATE(tip,0)->state = %d; /* %s */"
        uname (num_of_state ist.label) ist.label);
      List.iter (fun (k,_,_) ->
        e.p (sprintf "%s_STATE(tip,0)->%s = 0;" uname k);
      ) (List.map ocaml_type_of_arg registers);
    );
    e.p "}";
    e.nl ();
    let is_sink_state state = List.length state.edges = 0 in
    (* Execute a state until we cant any more. sym is the symbol register table *)
    let rec tickfn e sym from_state targ =
      e.p (sprintf "/* event %s -> %s */" from_state.label targ.label);
      let mfn fn = List.filter (fun x -> fn x.t) targ.edges in
      let msgtrans = mfn (function Message _ -> true |_ -> false) in
      let condtrans = mfn (function Condition _ -> true |_ -> false) in
      let asstrans = mfn (function Assignment _ -> true |_ -> false) in
      let aborttrans = mfn (function |Terminate -> true |_ -> false) in
      (* Helper fun to get register value or default *)
      let reg_value reg_name =
        try
          let expr = List.assoc reg_name sym in
          ocaml_string_of_expr expr
        with Not_found ->
          sprintf "%s_STATE(tip,i)->%s" uname reg_name
      in
      if List.length aborttrans > 0 then begin
        e.p "return 1; /* TESLA_ABORT */";
      end else begin
         if List.length msgtrans > 0 || (is_sink_state targ) then begin
           (* For each register, set it in the state descriptor *)
           List.iter (fun reg ->
             let reg_name = var_name_of_arg reg in
             e.p (sprintf "tmpstate.%s = %s;" reg_name (reg_value reg_name))
           ) registers;
           e.p (sprintf "tmpstate.state = %d;" (num_of_state targ.label));
           e.p ("memcpy(&(newstate[curpos]), &tmpstate, 1);");
           e.p "curpos++;";
         end;
      (* Group common conditionals together *)
      let condhash = Hashtbl.create 1 in
      List.iter (fun x -> match x.t with
        |Condition c -> hashtbl_add_list condhash (reduce_expr sym c) x
        |_ -> failwith "err") condtrans;

      (* Partition conditionals into value checks against consts and other *)
      let condvals = Hashtbl.create 1 in
      let condother = Hashtbl.create 1 in
      Hashtbl.iter (fun c xs ->
        match c with
        |Equals (Identifier i, Int_constant v) ->
          hashtbl_add_list condvals i (v,xs)
        |_ -> Hashtbl.add condother c xs
      ) condhash;

      (* Pattern match conditionals *)
      Hashtbl.iter (fun i vxs ->
        e.p (sprintf "switch (%s) {" (reg_value i));
        List.iter (fun (v,xs) ->
          e.p (sprintf " case %d:" v);
          indent_fn e (fun e ->
            List.iter (fun x -> tickfn e sym from_state !(x.target)) xs;
            e.p "break;"
          );
        ) vxs;
        e.p " default:";
        indent_fn e (fun e ->
          e.p "return 1; /* TESLA_INTERNAL_ERROR */";
        );
        e.p "}";
      ) condvals;

      (* All other conditionals *)
      Hashtbl.iter (fun c xs ->
        match c with
        |True ->
          e.p (sprintf "/* if (%s) */" (ocaml_string_of_expr c));
          indent_fn e (fun e ->
            List.iter (fun x -> tickfn e sym from_state !(x.target)) xs);
        |False ->
          e.p (sprintf "/* skipped %s */" (ocaml_string_of_expr c));
        |c ->
          e.p (sprintf "if (%s) {" (ocaml_string_of_expr ~reduce:reg_value c));
          indent_fn e (fun e ->
            List.iter (fun x -> tickfn e sym from_state !(x.target)) xs);
          e.p "}"
        ) condother;

      (* Assignment blocks *)
      List.iter (fun x -> match x.t with
        |Assignment (var,expr) ->
          e.p (sprintf "/* register %s = %s */" var (ocaml_string_of_expr (reduce_expr sym expr)));
          tickfn e ((var,expr)::sym) from_state !(x.target);
        |_ -> ()
       ) asstrans;
      end
    in
    (* Output the main automata prod function that accepts events *)
    e.p "int";
    e.p (sprintf "%s_automata_prod(struct tesla_instance *tip, u_int event)"
      env.sname);
    e.p "{";
    indent_fn e (fun e ->
      e.p "unsigned char newstate[16];";
      e.p "u_int i, curpos=1;";
      e.p (sprintf "struct %s tmpstate;" func_name);
      e.p "bzero(newstate, sizeof(newstate));";
      e.p "switch (event) {";
      Hashtbl.iter (fun scall funcs ->
        (* Find statecall event integer from the array *)
        let scnum = ref (-1) in
        Array.iteri (fun i s -> if s = scall then scnum := i) env.scnum;
        e.p (sprintf "case %d:  /* EVENT_%s */" !scnum (String.uppercase scall));
        indent_fn e (fun e ->
          e.p (sprintf "for (i=0; i < %s_NUM_STATES(tip); i++) {" uname);
          indent_fn e (fun e ->
            e.p (sprintf "switch (%s_STATE(tip,i)->state) {" uname);
            let valid_states = valid_states_for_statecall block_list scall in
            List.iter (fun (state,targets) ->
              let state_name = state.label in
              e.p (sprintf "case %d:" (num_of_state state_name));
              indent_fn e (fun e ->
                (* default symbol table is existing register values *)
                List.iter (tickfn e [] state) targets;
                e.p "break;";
              );
            ) valid_states;
          e.p "default:";
          indent_fn e (fun e -> e.p "break;");
          e.p "}";
        );
        e.p "}";
        e.p ("newstate[0] = curpos-1;");
        e.p ("if (newstate[0] == 0)");
        indent_fn e (fun e -> e.p ("return 1; /* TESLA_ERROR */"));
        e.p (sprintf "memcpy(%s_PTR(tip), &newstate, sizeof(newstate));" uname);
        e.p "return 0;";
      );
      e.nl ()
    ) env.statecalls;
    e.p "default:";
    indent_fn e (fun e -> e.p "return 1; /* TESLA_UNKNOWN_EVENT */");
    e.p "}";
    );
    e.p "}";
  ) env;
  e.nl ()

(* Populate hashtable with (statecall -> [automaton using it list]) *)
let rec extract_statecalls fname env func_env =
    let add s = hashtbl_add_list env.statecalls (String.capitalize s) fname in
    Hashtbl.iter (fun k state ->
        List.iter (fun edge -> match edge.t with
        |Message id -> add id |_ -> ()
        ) state.edges
    ) func_env.blocks;
    (* Also extract statecalls from any functions called by this automaton *)
    Hashtbl.iter (fun f _ ->
        try let x,_ = Hashtbl.find env.funcs f in
            extract_statecalls fname env x
        with Not_found -> failwith "internal compiler error"
    ) func_env.functions_called

let rec state_to_num counter env fenv =
    Hashtbl.iter (fun sname _ ->
        try let _ = Hashtbl.find env.statenum sname in
            ()
        with Not_found -> begin
            incr counter;
            Hashtbl.add env.statenum sname !counter
        end
    ) fenv.blocks;
    Hashtbl.iter (fun f _ ->
        try let x,_ = Hashtbl.find env.funcs f in
            state_to_num counter env x
        with Not_found -> failwith "internal compiler error"
    ) fenv.functions_called

(* Map statecall events to integers *)
let generate_statecall_numbers env =
  let a = Array.create (Hashtbl.length env.statecalls) "" in
  let pos = ref 0 in
  Hashtbl.iter (fun k v -> a.(!pos) <- k; incr pos) env.statecalls;
  env.scnum <- a
  
let generate_interface genv env e =
  Hashtbl.iter (fun _ (cfgenv, _) ->
    List.iter e.p cfgenv.externs
  ) env.funcs
  
let generate_header env sfile e =
  let modname = String.uppercase sfile in
  let lname = String.lowercase sfile in
  let comment xs = 
    e.p "/*";
    List.iter (fun x -> e.p (sprintf " * %s" x)) xs;
    e.p " */" in
  comment [ sprintf "This file is autogenerated by the Tesla CFA compiler";
    (sprintf "via: %s" (String.concat " " (Array.to_list (Sys.argv))))] ;
  e.nl ();
  e.p (sprintf "#ifndef %s_DEFS_H" modname);
  e.p (sprintf "#define %s_DEFS_H" modname);
  e.nl ();
  e.p "#include <sys/types.h>";
  e.nl ();
  comment [ sprintf "Names for events that will trigger %s rules" modname ];
  Array.iteri (fun i name ->
    let name' = String.uppercase name in
    e.p (sprintf "#define %s_EVENT_%s %d" modname name' i)
  ) env.scnum;
  e.nl ();
  comment [sprintf "Prod the %s state machine, return (1) if the assertion failed" modname];
  e.p "struct tesla_instance;";
  e.p (sprintf "void %s_automata_init(struct tesla_instance *);" lname);
  e.p (sprintf "int %s_automata_prod(struct tesla_instance *tip, u_int event);" lname);
  e.nl ();
  comment ["\"Public\" interfaces to the assertion, to be invoked by load, unload";
    "and instrumentation handlers."];
  e.p (sprintf "#ifndef _KERNEL");
  e.p (sprintf "void	%s_init(int scope);" lname);
  e.p (sprintf "void	%s_destroy(void);" lname);
  e.p (sprintf "void    %s_setaction_debug(void);" lname);
  e.p (sprintf "#endif");
  e.p (sprintf "#endif /* %s_DEFS_H */" modname)
  
let generate sfile ofiles debug genvs =
    let counter = ref 0 in
    if List.length genvs > 1 then
       failwith "TESLA only supports 1 SPL input at a time for now";
    List.iter2 (fun genv ofile ->
      let mlout = open_out (ofile ^ "_automata.c") in
      let penvml = init_printer ~header:false mlout in
      let env = { statenum=Hashtbl.create 1; statecalls=Hashtbl.create 1;
        scnum=[||]; funcs=genv.functions; debug=debug; sname=sfile} in
      export_fun_iter (fun fname fenv fdef -> extract_statecalls fname env fenv) env;
      export_fun_iter (fun _ fenv _ -> state_to_num counter env fenv) env;
      generate_statecall_numbers env;
      Hashtbl.iter (fun scall l ->  Hashtbl.replace env.statecalls
        scall (list_unique l)) env.statecalls;
      let schan = open_out (sfile ^ ".spec") in
      let pifaceout = init_printer ~header:false schan in
      let hout = open_out (sfile ^ "_defs.h") in
      let hprinter = init_printer ~header:false hout in
      generate_header env sfile hprinter;
      generate_interface genv env pifaceout;
      pp_env genv env penvml;
      close_out mlout;
      close_out schan;
      close_out hout
    ) genvs ofiles
