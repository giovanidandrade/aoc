exception InvalidDescription of string

type box = { length : int; width : int; height : int }

let box_of_string description =
  let dimensions = Str.split (Str.regexp "x") description in
  match dimensions with
  | [ l; w; h ] ->
      {
        length = int_of_string l;
        width = int_of_string w;
        height = int_of_string h;
      }
  | _ -> raise (InvalidDescription description)

let box_areas { length; width; height } =
  (length * width, width * height, height * length)

let wrapping_paper_area description =
  let box = box_of_string description in
  let a1, a2, a3 = box_areas box in
  let smallest_area = min (min a1 a2) a3 in
  (2 * (a1 + a2 + a3)) + smallest_area

let feet_for_bow { length; width; height } = length * width * height

let feet_for_sides { length; width; height } =
  let biggest_side = max (max length width) height in
  2 * (length + width + height - biggest_side)

let ribbon_feet description =
  let box = box_of_string description in
  feet_for_bow box + feet_for_sides box
