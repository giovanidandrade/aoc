import std/tables

proc santaWalk(directions: string): int =
    var table = initTable[(int, int), bool]()

    var position = (0, 0)
    table[position] = true
    var numberHouses = 1

    for _, direction in directions[0 .. ^1]:
        case direction
        of '^': position[1] += 1
        of 'v': position[1] -= 1
        of '<': position[0] -= 1
        of '>': position[0] += 1
        else: discard

        if position notin table:
            table[position] = true
            numberHouses += 1
    
    return numberHouses

proc roboWalk(directions: string): int =
    var table = initTable[(int, int), bool]()

    var positions = [
        (0, 0),
        (0, 0)
    ]
    var index = 0

    table[positions[index]] = true
    var numberHouses = 1

    for _, direction in directions[0 .. ^1]:

        case direction
        of '^': positions[index][1] += 1
        of 'v': positions[index][1] -= 1
        of '<': positions[index][0] -= 1
        of '>': positions[index][0] += 1
        else: discard

        if positions[index] notin table:
            table[positions[index]] = true
            numberHouses += 1
        
        index = (index + 1) mod 2
    
    return numberHouses

let input = readFile("input.txt")

echo "Part 1: ", santaWalk(input), " houses"
echo "Part 2: ", roboWalk(input), " houses"