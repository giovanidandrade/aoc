open Year15
open Utils
open Format

let () =
  Io.lines "input.txt" |> List.map Day2.ribbon_feet |> List.fold_left ( + ) 0
  |> printf "%d\n"
