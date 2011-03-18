open Printf

(* calculate average of a list of floats *)
let average l =
    let len = float_of_int (List.length l) in
    let sum = List.fold_left (+.) 0. l in
    sum /. len

(* calculate standard deviation of a list of floats *)
let std_dev l =
    let fl = float_of_int (List.length l) in
    let sqdev s = ((average l) -. s) ** 2. in
    let sumsqdev = List.fold_left (fun a b -> a +. (sqdev b)) 0. l in
    sqrt (sumsqdev /. (fl -. 1.))

let parse h file =
  let fin = open_in file in
  let fout = open_out "analysed.results" in
  (try while true do
        let l = input_line fin in
	let bits = Str.split (Str.regexp_string " ") l in
        match bits with
        |name :: opt :: data ->
          let data = List.map float_of_string data in
          let avg = average data in
          let std = std_dev data in
	  Hashtbl.add h (name, opt) (avg, std);
          fprintf fout "%s %s %f %f\n%!" name opt avg std
        |_ -> assert false
  done with End_of_file -> close_in fin; close_out fout)

let gnuplot h =
  let fout = open_out "gnuplot.dat" in
  List.iter (fun opt ->
    fprintf fout "-O%s" opt;
    List.iter (fun cc ->
      let (avg,std) = Hashtbl.find h (cc, opt) in
      fprintf fout " %f %f" avg std
    ) ["instr_gcc"; "instr_clang_noinstr"; "instr_clang_instr_faketesla"; "instr_clang_instr_tesla"];
    fprintf fout "\n"
  ) ["0";"1";"2";"3"] ;
  close_out fout

let _ =
  let h = Hashtbl.create 1 in
  parse h "micro.results";
  gnuplot h
