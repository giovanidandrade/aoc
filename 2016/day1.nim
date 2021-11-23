import std/strutils

type
    Coords = object
        x: int
        y: int

    Direction = enum north, east, south, west
    Position = object
        x: int
        y: int
        facing: Direction

proc turnLeft(pos: Position): Position =
    result = pos

    # Same as -1 but avoids sign problems
    let dir = (ord(pos.facing) + 3) mod 4
    result.facing = Direction(dir)

    return result

proc turnRight(pos: Position): Position =
    result = pos

    let dir = (ord(pos.facing) + 1) mod 4
    result.facing = Direction(dir)

    return result

proc charge(pos: Position, blocks: int): Position =
    result = pos

    case pos.facing:
    of north: result.y += blocks
    of east: result.x += blocks
    of south: result.y -= blocks
    of west:result.x -= blocks

    return result

proc processDirections(walk: seq[string]): int =
    var pos: Position
    for dir in walk[0 .. ^1]:
        if dir[0] == 'L':
            pos = pos.turnLeft()
        else:
            pos = pos.turnRight()
        
        let blocks = dir[1 .. ^1].parseInt()
        pos = pos.charge(blocks)
    
    return abs(pos.x) + abs(pos.y)

proc distTwice(walk: seq[string]): int =
    var pos: Position

    var memory = newSeq[Coords]()
    memory.add(Coords(x: 0, y: 0))

    var n = 0
    var index = 0
    while n < 5000:
        let dir = walk[index]
        if dir[0] == 'L':
            pos = pos.turnLeft()
        else:
            pos = pos.turnRight()
        
        let blocks = dir[1 .. ^1].parseInt()
        for _ in 1 .. blocks:
            pos = pos.charge(1)

            let coords = Coords(x: pos.x, y: pos.y)
            if coords in memory:
                return coords.x.abs() + coords.y.abs()
            else:
                memory.add(coords)

        index = (index + 1) mod walk.len
        n += 1
    
    return -1

let input = readFile("input.txt").split(", ")

echo "Part 1: ", input.processDirections()
echo "Part 2: ", input.distTwice()