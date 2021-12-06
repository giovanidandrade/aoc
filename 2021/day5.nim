import std/strutils
import std/sequtils
from std/math import sgn

type
    # x1, y1 -- x2, y2
    Line = (int, int, int, int)
    Grid = seq[seq[int]]

proc parseLine(line: string): Line =
    let coords = line.split(" -> ")

    result[0] = coords[0].strip().split(',')[0].parseInt()
    result[1] = coords[0].strip().split(',')[1].parseInt()
    result[2] = coords[1].strip().split(',')[0].parseInt()
    result[3] = coords[1].strip().split(',')[1].parseInt()

    return result

proc isStraight(line: Line): bool =
    return line[0] == line[2] or
           line[1] == line[3]

proc getPoints(grid: Grid): int =
    for row in grid:
        result += row
            .filterIt(it >= 2)
            .foldl(a + 1, 0)
    
    return result

proc makeGrid(lines: seq[Line]): Grid =
    var maxDim = low(int)
    for line in lines:
        maxDim = max(
            maxDim,
            max(
                max(line[0], line[1]),
                max(line[2], line[3])
            )
        )
    
    return repeat(
        repeat(0, maxDim + 1),
        maxDim + 1
    )

proc populate(grid: Grid, lines: seq[Line]): Grid =
    result = grid

    for line in lines:
        # Vertical line
        if line[0] == line[2]:
            let x = line[0]
            let yMin = min(line[1], line[3])
            let yMax = max(line[1], line[3])

            for y in yMin .. yMax:
                result[y][x] += 1
        
        # Horizontal line
        elif line[1] == line[3]:
            let y = line[1]
            let xMin = min(line[0], line[2])
            let xMax = max(line[0], line[2])
            
            for x in xMin .. xMax:
                result[y][x] += 1
        
        # Diagonal line
        else:
            let dx = sgn(line[2] - line[0])
            let dy = sgn(line[3] - line[1])

            var x = line[0]
            var y = line[1]
            while x != line[2] + dx:
                result[y][x] += 1
                x += dx
                y += dy
    
    return result

let input = readFile("input.txt")
    .split('\n')
    .map(parseLine)

let grid = makeGrid(input)

echo "Part 1: ", grid.populate(
        input.filter(isStraight)
    ).getPoints()

echo "Part 2: ", grid.populate(input).getPoints()