import std/strutils

type
    Position = object
        x: int
        y: int
        aim: int

proc parseDirection(dir: string, p0: Position): Position =
    result = p0

    case dir[0]
    of 'u':
        result.y -= dir["up ".len .. ^1].parseInt()
    of 'd':
        result.y += dir["down ".len .. ^1].parseInt()
    of 'f':
        result.x += dir["forward ".len .. ^1].parseInt()
    else:
        echo "Something went wrong: ", dir

proc parseDirectionNew(dir: string, p0: Position): Position =
    result = p0

    case dir[0]
    of 'u':
        result.aim -= dir["up ".len .. ^1].parseInt()
    of 'd':
        result.aim += dir["down ".len .. ^1].parseInt()
    of 'f':
        let units = dir["forward ".len .. ^1].parseInt()
        result.x += units
        result.y += result.aim * units
    else:
        echo "Something went wrong: ", dir

let input = readFile("input.txt")
    .split("\n")

var p: Position
var s: Position
for line in input:
    p = line.parseDirection(p)
    s = line.parseDirectionNew(s)

echo "Part 1: ", p.x * p.y
echo "Part 2: ", s.x * s.y