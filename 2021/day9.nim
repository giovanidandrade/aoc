import std/sequtils
import std/strutils
import std/sugar
import std/sets
import std/algorithm

type Env = HashSet[(int, int)]

proc checkLowPoint(heightmap: seq[seq[int]]): seq[(int, int)] =
    for i in 0 ..< heightmap.len:
        for j in 0 ..< heightmap[0].len:
            var isLow = true

            if i > 0:
                isLow = isLow and heightmap[i][j] < heightmap[i - 1][j]
            
            if j > 0:
                isLow = isLow and heightmap[i][j] < heightmap[i][j - 1]
            
            if i != heightmap.len - 1:
                isLow = isLow and heightmap[i][j] < heightmap[i + 1][j]
            
            if j != heightmap[0].len - 1:
                isLow = isLow and heightmap[i][j] < heightmap[i][j + 1]
            
            if isLow:
                result.add((i, j))
    
    return result

proc findBasinSize(heightmap: seq[seq[int]], state: (int, int), env: var Env ): int =
    let i = state[0]
    let j = state[1]

    if i < 0 or j < 0:
        return 0

    if i >= heightmap.len or j >= heightmap[0].len:
        return 0

    if heightmap[i][j] == 9:
        return 0

    # No double counting
    if (i, j) in env:
        return 0

    env.incl((i, j))
    for offsets in [          (0, -1),
                    (-1,  0),          (1,  0),
                              (0,  1)]:
        let dx = offsets[0]
        let dy = offsets[1]
        result += findBasinSize(heightmap, (i + dx, j + dy), env)
    
    return result + 1

let input = readFile("input.txt")
    .split("\n")
    .mapIt(it.items.toSeq)
    .map(cs => cs.mapIt(int(it) - int('0')))

let lows = input.checkLowPoint()

echo "Part 1: ", lows
    .map(tp => input[tp[0]][tp[1]])
    .foldl(a + b + 1, 0)

var basinSizes: seq[int]
for lowpoint in lows:
    var env: Env
    basinSizes.add(
        findBasinSize(input, lowpoint, env)
    )

sort(basinSizes)

echo "Part 2: ", basinSizes[^1] * basinSizes[^2] * basinSizes[^3]