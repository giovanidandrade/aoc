exception NeverBasement of string

let int_of_parens ch =
  match ch with
  | '(' -> 1
  | ')' -> -1
  (* We can safely ignore everything that isn't a paren *)
  | _ -> 0

let rec first_to_basement floor position directions =
  match directions with
  | current_dir :: next_dirs ->
      let new_floor = floor + int_of_parens current_dir in
      if floor = -1 then position
      else first_to_basement new_floor (position + 1) next_dirs
  | [] ->
      if floor = -1 then position
      else raise (NeverBasement "Santa never went to the basement.")

let count_parens directions =
  directions |> String.to_seq |> Seq.map int_of_parens |> Seq.fold_left ( + ) 0

let basement_position directions =
  directions |> String.to_seq |> List.of_seq |> first_to_basement 0 0