from std/strutils import split, parseInt
from std/sequtils import map, foldl
import std/sugar

type
    Grid = array[1000, array[1000, int]]
    Kind = enum on, off, toggle
    Instruction = object
        kind: Kind
        coord0: (int, int)
        coord1: (int, int)

proc totalSum(grid: Grid): int =
    grid.map(arr => arr.foldl(a + b, 0)).foldl(a + b, 0)

proc parseInstruction(description: string): Instruction =
    let tokens = description.split(' ')

    if tokens.len == 4:
        let arr0 = tokens[1].split(',').map(parseInt)
        let coord0 = (arr0[0], arr0[1])

        let arr1 = tokens[3].split(',').map(parseInt)
        let coord1 = (arr1[0], arr1[1])

        return Instruction(kind: toggle, coord0: coord0, coord1: coord1)
    
    let kind = if tokens[1] == "on": on else: off

    let arr0 = tokens[2].split(',').map(parseInt)
    let coord0 = (arr0[0], arr0[1])

    let arr1 = tokens[4].split(',').map(parseInt)
    let coord1 = (arr1[0], arr1[1])

    return Instruction(kind: kind, coord0: coord0, coord1: coord1)

proc execInstructionOld(grid: var Grid, instruction: Instruction) =
    let fn = (
        case instruction.kind
        of on: (_:int) => 1
        of off: (_:int) => 0
        of toggle: (x: int) => (if x == 0: 1 else: 0)
    )

    let (x0, y0) = instruction.coord0
    let (x1, y1) = instruction.coord1

    for x in x0..x1:
        for y in y0..y1:
            grid[x][y] = fn(grid[x][y])

proc execInstruction(grid: var Grid, instruction: Instruction) =
    let fn = (
        case instruction.kind
        of on: (x: int) => x + 1
        of off: (x: int) => max(0, x - 1)
        of toggle: (x: int) => x + 2
    )

    let (x0, y0) = instruction.coord0
    let (x1, y1) = instruction.coord1

    for x in x0..x1:
        for y in y0..y1:
            grid[x][y] = fn(grid[x][y])

let input = readFile("input.txt").split('\n')

var oldGrid: Grid
var newGrid: Grid

for _, description in input[0 .. ^1]:
    let instruction = parseInstruction(description)

    oldGrid.execInstructionOld(instruction)
    newGrid.execInstruction(instruction)

echo "Part 1: ", oldGrid.totalSum()
echo "Part 2: ", newGrid.totalSum()