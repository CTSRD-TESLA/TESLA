open Printf

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
    printf "%s,%s\n%!" ty (String.concat "," (List.map string_of_float tms))
  ) all
