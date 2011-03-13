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
    statecalls: (id, string list) Hashtbl.t; (* Statecall name, functions which use it *)
    funcs: (string, (Spl_cfg.env * func)) Hashtbl.t;
    debug: bool;
}

let rec reduce_expr sym ex =
    let rec fn = function
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
    | Integer x -> (x, "int",false)
    | Boolean x -> (x, "uint8_t",false)
    | Unknown x -> failwith "type checker invariant failure"

let initial_value_of_arg = function
    | Integer x -> sprintf "%s = 0" x
    | Boolean x -> sprintf "%s = false" x
    | Unknown x -> failwith "type checker invariant failure"

let ocaml_format_of_arg = function
    | Integer x -> (x, "%d")
    | Boolean x -> (x, "%B")
    | Unknown x -> failwith "type checker invariant failure"

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

(* Pretty-print a "module blah = struct end" *)
let pp_module e m fn = 
    e.p (sprintf "module %s = struct" (String.capitalize m));
    indent_fn e fn;
    e.p "end";
    e.nl ()

(* Pretty-print a "module blah:sig end" *)
let pp_module_sig e m fn =
    e.p (sprintf "module %s : sig" (String.capitalize m));
    indent_fn e fn;
    e.p "end";
    e.nl ()

(* Pretty-print a state struct *)
let pp_record_type e tname t =
  e.p (sprintf "struct %s {" tname);
  indent_fn e (fun e ->
    e.p "int state;";
    List.iter (fun (nm,ty,m) ->
      e.p (sprintf "%s %s;" ty nm)
    ) t;
  );
  e.p "};";
  e.nl ()

let pp_env env e =
  e.p "#include <stdio.h>";
  e.p "#include <stdint.h>";
  let num_of_state s = Hashtbl.find env.statenum s in
  e.nl ();
  export_fun_iter (fun func_name func_env func_def ->
    let block_list = blocks_of_function func_env env.funcs in
    let registers = list_of_registers func_env in
    pp_record_type e func_name (List.map ocaml_type_of_arg registers);
    e.p (sprintf "void %s_init(struct %s *s) {" func_name func_name);
    indent_fn e (fun e ->
      let ist = initial_state_of_env func_env in
      e.p (sprintf "s->state = %d; /* %s */" (num_of_state ist.label) ist.label);
      List.iter (fun (k,_,_) ->
        e.p (sprintf "s->%s = 0;" k);
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
          sprintf "s1[i].%s" reg_name
      in
      if List.length aborttrans > 0 then begin
        e.p "tesla_abort();"
      end else begin
         if List.length msgtrans > 0 || (is_sink_state targ) then begin
           (* For each register, set it in the state descriptor *)
           List.iter (fun reg ->
             let reg_name = var_name_of_arg reg in
             e.p (sprintf "s2[curpos].%s = %s;" reg_name (reg_value reg_name))
           ) registers;
           e.p (sprintf "s2[curpos].state = %d;" (num_of_state targ.label));
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
          e.p "tesla_internal_error ();";
          e.p "break;";
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
    (* Output a function for each input event *)
    Hashtbl.iter (fun scall funcs ->
      e.p (sprintf "int %s_event_%s(struct %s *s1, int sz, struct %s *s2) {"
        func_name scall func_name func_name);
      indent_fn e (fun e ->
        (* s1[sz] is current state and we place result in s2 and return [curpos] *)
        e.p "uint8_t i,curpos=0;";
        e.p "for (i=0; i<sz; i++) {";
        indent_fn e (fun e ->
          e.p "switch (s1[i].state) {";
          let valid_states = Spl_cfg.valid_states_for_statecall block_list scall in
          List.iter (fun (state,targets) ->
            let state_name = state.Spl_cfg.label in
            e.p (sprintf "case %d:" (num_of_state state_name));
            indent_fn e (fun e ->
              (* default symbol table is existing register values *)
              List.iter (tickfn e [] state) targets;
              e.p "break;";
            );
          ) valid_states;
          e.p "default:";
          indent_fn e (fun e -> e.p "tesla_error();");
          e.p "}";
        );
        e.p "}";
      );
      e.p "return curpos;";
      e.p "}";
      e.nl ()
    ) env.statecalls;
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
            let n = !counter in
            incr counter;
            Hashtbl.add env.statenum sname n
        end
    ) fenv.blocks;
    Hashtbl.iter (fun f _ ->
        try let x,_ = Hashtbl.find env.funcs f in
            state_to_num counter env x
        with Not_found -> failwith "internal compiler error"
    ) fenv.functions_called

let generate_interface envs e =
    let statecalls = Hashtbl.create 1 in
    List.iter (fun env -> Hashtbl.iter 
        (fun k v -> Hashtbl.replace statecalls k ()) env.statecalls) envs;
    let names = List.sort Pervasives.compare 
        (Hashtbl.fold (fun k v a -> k :: a) statecalls []) in
    List.iter (fun name ->
      let bits = Str.split (Str.regexp_string "_") (String.lowercase name) in
      match bits with
      | "assign" :: struct_name :: field_name :: value ->
          e.p (String.concat "," bits)
      | "net" :: mode :: [flag] ->
          e.p (sprintf "net,%s,,%s" mode flag)
      | "invoke" :: tl ->
          e.p (sprintf "invoke,%s" (String.concat "_" tl))
      | x ->
          e.p (sprintf "UNKNOWN,%s" (String.concat "_" x))
    ) names;
    e.nl ()
    
let generate sfile ofiles debug genvs  =
    let counter = ref 0 in
    let schan = open_out (sfile ^ ".spec") in
    let envs = List.map2 (fun genv ofile ->
      let mlout = open_out (ofile ^ ".c") in
      let penvml = init_printer ~header:false mlout in
      let env = { statenum = Hashtbl.create 1; statecalls = Hashtbl.create 1;
        funcs = genv.functions; debug=debug; } in
      export_fun_iter (fun fname fenv fdef -> extract_statecalls fname env fenv) env;
      export_fun_iter (fun _ fenv _ -> state_to_num counter env fenv) env;
      Hashtbl.iter (fun scall l ->  Hashtbl.replace env.statecalls
        scall (list_unique l)) env.statecalls;
      pp_env env penvml;
      close_out mlout;
      env
    ) genvs ofiles in
    let pifaceout = init_printer schan in
    generate_interface envs pifaceout;
    close_out schan
