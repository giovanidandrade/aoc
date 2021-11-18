open Year15
open Utils
open Format

let () =
  Io.slurp_file "input.txt" |> Day3.threaded_count_houses |> printf "%d\n"
