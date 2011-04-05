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

let parse file sz =
  let fin = open_in ("results/res_"^file^"."^sz) in
  let res = ref [] in
  (try while true do
     (try
        let l = input_line fin in
        Scanf.sscanf l "%d bytes transferred in %f secs (%d bytes/sec)"
          (fun _ tm _ -> res := tm :: !res)
      with Scanf.Scan_failure _ -> ()
     )
  done with End_of_file -> close_in fin);
  (List.rev !res)

let _ =
  let sizes = List.map (sprintf "%dk")
   [50; 100; 150; 200; 250; 300; 350; 400; 450; 500; 550; 600; 650; 700; 750; 800; 850; 900; 950; 1000 ] in
  let sizes = List.map (sprintf "%dk")
   [100; 200; 300; 400; 500; 600; 700; 800; 900; 1000 ] in
  let datfile = open_out "ssh_data.dat" in
  List.iter (fun sz ->
    List.iter (fun fl ->
     let tms = parse fl sz in
     let sz' = String.copy sz in
     sz'.[String.length sz' - 1] <- 'M';
     fprintf datfile "%sB" sz';
     let av = average tms in
     let std = std_dev tms in
     fprintf datfile " %f %f" av std
    ) [ "clang_notesla";"clang_tesla";"gcc_notesla" ] ;
    fprintf datfile "\n%!";
  ) sizes;
  close_out datfile
