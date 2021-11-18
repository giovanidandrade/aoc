exception InvalidInstruction of string

exception InvalidRange

type range = int * int

type instruction =
  | TurnOn of range * range
  | Toggle of range * range
  | TurnOff of range * range

let parse_int_pair str =
  Str.split (Str.regexp ",") str |> List.map int_of_string

let range_of_list list =
  match list with [ c; d ] -> (c, d) | _ -> raise InvalidRange

let parse_range str =
  let range_strings = Str.split (Str.regexp " through ") str in
  let range_list =
    range_strings |> List.map parse_int_pair |> List.map range_of_list
  in
  match range_list with [ a; b ] -> (a, b) | _ -> raise InvalidRange

let remove_prefix ~prefix str =
  let length = String.length str in
  let prefix_size = String.length prefix in
  String.sub str prefix_size (length - prefix_size)

let parse_instruction str =
  if String.starts_with ~prefix:"turn on " str then
    let r0, r1 = parse_range (remove_prefix ~prefix:"turn on " str) in
    TurnOn (r0, r1)
  else if String.starts_with ~prefix:"toggle " str then
    let r0, r1 = parse_range (remove_prefix ~prefix:"toggle " str) in
    Toggle (r0, r1)
  else if String.starts_with ~prefix:"turn off " str then
    let r0, r1 = parse_range (remove_prefix ~prefix:"turn off " str) in
    TurnOff (r0, r1)
  else raise (InvalidInstruction str)

let index x y = x + (y * 1000)

let rec iter_vertical x y0 y1 fn =
  let () = fn (index x y0) in
  if y0 = y1 then () else iter_vertical x (y0 + 1) y1 fn

let rec iter_ranges (x0, y0) (x1, y1) fn =
  let () = iter_vertical x0 y0 y1 fn in
  if x0 = x1 then () else iter_ranges (x0 + 1, y0) (x1, y1) fn

let rec exec_instructions instructions grid =
  match instructions with
  | elem :: next_instructions ->
      let fn, r0, r1 =
        match elem with
        | TurnOn (r0, r1) ->
            let fn idx =
              let value = Array.get grid idx in
              Array.set grid idx (value + 1)
            in
            (fn, r0, r1)
        | TurnOff (r0, r1) ->
            let fn idx =
              let value = Array.get grid idx in
              Array.set grid idx (max (value - 1) 0)
            in
            (fn, r0, r1)
        | Toggle (r0, r1) ->
            let fn idx =
              let value = Array.get grid idx in
              Array.set grid idx (value + 2)
            in
            (fn, r0, r1)
      in
      let () = iter_ranges r0 r1 fn in
      exec_instructions next_instructions grid
  | [] -> grid

let light_grid instructions =
  let instruction_list = List.map parse_instruction instructions in
  let grid = Array.make (1000 * 1000) 0 in
  exec_instructions instruction_list grid