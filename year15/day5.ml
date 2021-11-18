let number_vowels str =
  str |> String.to_seq
  |> Seq.map (String.contains "aeiou")
  |> Seq.map (fun b -> if b then 1 else 0)
  |> Seq.fold_left ( + ) 0

let has_double_letter str =
  let char_list = str |> String.to_seq |> List.of_seq in
  let rec helper chars ch =
    match chars with
    | c :: d :: next_chars -> (c = ch && d = ch) || helper (d :: next_chars) ch
    | _ -> false
  in
  "abcdefghijklmnopqrstuvwxyz" |> String.to_seq
  |> Seq.map (helper char_list)
  |> Seq.fold_left ( || ) false

let has_forbidden_substring str =
  let char_list = str |> String.to_seq |> List.of_seq in
  let rec helper chars (c1, c2) =
    match chars with
    | c :: d :: next_chars ->
        (c == c1 && d == c2) || helper (d :: next_chars) (c1, c2)
    | _ -> false
  in
  [ ('a', 'b'); ('c', 'd'); ('p', 'q'); ('x', 'y') ]
  |> List.map (helper char_list)
  |> List.fold_left ( || ) false

let is_nice_old str =
  number_vowels str >= 3
  && has_double_letter str
  && not (has_forbidden_substring str)

let rec has_repeating_pair str =
  if String.length str < 2 then false
  else
    let pattern = Str.regexp (Str.first_chars str 2) in
    let tail = Str.string_after str 1 in
    try Str.search_forward pattern tail 0 >= 0
    with Not_found -> has_repeating_pair tail

let rec has_overlap chars =
  match chars with
  | c :: d :: e :: next_chars ->
      (c = d && d = e && e = c) || has_overlap (d :: e :: next_chars)
  | _ -> false

let rec sandwiched_letter chars =
  match chars with
  | c :: d :: e :: next_chars ->
      c = e || sandwiched_letter (d :: e :: next_chars)
  | _ -> false

let is_nice str =
  let char_list = str |> String.to_seq |> List.of_seq in
  has_repeating_pair str
  && (not (has_overlap char_list))
  && sandwiched_letter char_list
