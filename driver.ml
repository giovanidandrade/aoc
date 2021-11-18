open Year15
open Utils
open Format

let () =
  let key = Io.slurp_file "input.txt" in
  let number = Day4.first_md5 key "000000" 0 in
  printf "%d\n" number
