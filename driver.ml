open Year15
open Utils
open Format

let () =
  Io.lines "input.txt" |> List.map Day5.is_nice
  |> List.map (fun b -> if b then 1 else 0)
  |> List.fold_left ( + ) 0 |> printf "%d\n"
