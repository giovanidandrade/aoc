import std/sequtils
import std/strutils

type
    Grid = seq[seq[int]]

proc parseGrid(description: seq[string], grid: var Grid, forceCorner = false) =
    let b = grid.len - 1
    for x, line in description[0 .. ^1]:
        for y, light in line[0 .. ^1]:
            grid[x][y] = (
                if forceCorner and x in [0, b] and y in [0, b]:
                    1
                else:
                    int(light == '#')
            )

proc numberLightsOn(grid: Grid): int =
    var sum = 0
    for line in grid[0 .. ^1]:
        for light in line[0 .. ^1]:
            sum += int(light)
    
    return sum

proc nextStep(grid: Grid, forceCorner = false): Grid =
    let b = grid.len - 1
    
    result = grid
    for x, line in grid[0 .. ^1]:
        for y, light in line[0 .. ^1]:
            var neighbors = 0
            
            neighbors += (if x != 0: grid[x - 1][y] else: 0)
            neighbors += (if x != b: grid[x + 1][y] else: 0)
            neighbors += (if y != 0: grid[x][y - 1] else: 0)
            neighbors += (if y != b: grid[x][y + 1] else: 0)
            neighbors += (if x != 0 and y != 0: grid[x - 1][y - 1] else: 0)
            neighbors += (if x != 0 and y != b: grid[x - 1][y + 1] else: 0)
            neighbors += (if x != b and y != b: grid[x + 1][y + 1] else: 0)
            neighbors += (if x != b and y != 0: grid[x + 1][y - 1] else: 0)

            if light == 1 and neighbors in [2, 3]:
                result[x][y] = 1
            elif light == 0 and neighbors == 3:
                result[x][y] = 1
            elif forceCorner and x in [0, b] and y in [0, b]:
                result[x][y] = 1
            else:
                result[x][y] = 0
    
    return result

let n = 100
var grid = repeat(
    repeat(0, n),
    n
)

let input = readFile("input.txt").split('\n')
parseGrid(input, grid)

for _ in 0 ..< 100:
    grid = nextStep(grid)

echo "Part 1: ", numberLightsOn(grid)

# Resetting for Part 2
grid = repeat(
    repeat(0, n),
    n
)

parseGrid(input, grid, true)

for _ in 0 ..< 100:
    grid = nextStep(grid, true)

echo "Part 2: ", numberLightsOn(grid)
