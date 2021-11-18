let update_position (x, y) direction =
  match direction with
  | '^' -> (x, y + 1)
  | 'v' -> (x, y - 1)
  | '<' -> (x - 1, y)
  | '>' -> (x + 1, y)
  (* We can safely ignore all other directions *)
  | _ -> (x, y)

let rec house_counter dirs position table number_houses =
  match dirs with
  | dir :: next_dirs ->
      let new_position = update_position position dir in
      if Hashtbl.mem table new_position then
        house_counter next_dirs new_position table number_houses
      else
        let () = Hashtbl.add table new_position () in
        house_counter next_dirs new_position table (number_houses + 1)
  | [] -> number_houses

let rec threaded_house_counter dirs position other_position table number_houses
    =
  match dirs with
  | dir :: next_dirs ->
      (* We do the same as before, but now we switch position and other_position *)
      let new_position = update_position position dir in
      if Hashtbl.mem table new_position then
        threaded_house_counter next_dirs other_position new_position table
          number_houses
      else
        let () = Hashtbl.add table new_position () in
        threaded_house_counter next_dirs other_position new_position table
          (number_houses + 1)
  | [] -> number_houses

let count_houses directions =
  let direction_list = directions |> String.to_seq |> List.of_seq in
  (* We're just eyeballing 64 for initial hash size since it's a pretty number *)
  let table = Hashtbl.create 64 in
  (* We assume Santa has already delivered a gift in this house *)
  let () = Hashtbl.add table (0, 0) () in
  house_counter direction_list (0, 0) table 1

let threaded_count_houses directions =
  let direction_list = directions |> String.to_seq |> List.of_seq in
  (* We're just eyeballing 64 for initial hash size since it's a pretty number *)
  let table = Hashtbl.create 64 in
  (* We assume Santa has already delivered a gift in this house *)
  let () = Hashtbl.add table (0, 0) () in
  threaded_house_counter direction_list (0, 0) (0, 0) table 1