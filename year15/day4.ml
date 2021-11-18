let is_valid_hash hash prefix =
  let hex_hash = Digest.to_hex hash in
  String.starts_with ~prefix hex_hash

let rec first_md5 key prefix number =
  let message = String.concat "" [ key; string_of_int number ] in
  let hash = Digest.string message in
  if is_valid_hash hash prefix then number else first_md5 key prefix (number + 1)
