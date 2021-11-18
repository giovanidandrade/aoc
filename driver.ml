open Year15
open Utils
open Format

let () = Io.slurp_file "input.txt" |> Day1.basement_position |> printf "%d\n"
