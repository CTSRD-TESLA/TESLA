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

let parse file =
  let fin = open_in ("res_"^file) in
  let res = ref [] in
  (try while true do
     (try
        let l = input_line fin in
        Scanf.sscanf l "%d bytes transferred in %f secs (%d bytes/sec)"
          (fun _ tm _ -> res := tm :: !res)
      with Scanf.Scan_failure _ -> ()
     )
  done with End_of_file -> close_in fin);
  (file,(List.rev !res))

let _ =
  let all = List.fold_left (fun a b -> parse b :: a)
    [] [ "clang_notesla";"clang_tesla";"gcc_notesla" ] in
  List.iter (fun (ty,tms) ->
    let avg_tm = average tms in
    let stddev_tm = std_dev tms in
    printf "%s,%f,%f\n%!" ty avg_tm stddev_tm
  ) all
