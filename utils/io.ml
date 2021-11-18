open Core

let slurp_file filename = In_channel.read_all filename

let lines filename = In_channel.read_lines filename