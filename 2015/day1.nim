proc count_floor(directions: string): int =
    var floor = 0

    for _, ch in directions[0 .. ^1]:
        case ch
        of '(': floor += 1
        of ')': floor -= 1
        else: discard
    
    return floor

proc first_to_basement(directions: string): int =
    var floor = 0

    for index, ch in directions[0 .. ^1]:
        case ch
        of '(': floor += 1
        of ')': floor -= 1
        else: discard

        if floor == -1:
            # The answer needs to be 1-indexed
            return index + 1
    
    return -1

let input = readFile("input.txt")

echo "Part 1: ", count_floor(input)
echo "Part 2: ", first_to_basement(input)