open Year15
open Utils
open Format

let () =
  Io.lines "input.txt" |> Day6.light_grid |> Array.to_seq
  |> Seq.fold_left ( + ) 0 |> printf "%d\n"
