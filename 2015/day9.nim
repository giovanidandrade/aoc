from std/strutils import split, parseInt
import std/sequtils
import std/tables
import std/re
import std/sugar

type
    CostMatrix = seq[seq[int]]

proc pushToMatrix(matrix: var CostMatrix, x: int, y: int, payload: int) =
    let bound = max(x, y)

    while bound >= matrix.len:
        matrix.add(@[0])
    
    for idx, _ in matrix[0 .. ^1]:
        while bound >= matrix[idx].len:
            matrix[idx].add(0)
    
    matrix[x][y] = payload
    matrix[y][x] = payload

proc makeCostMatrix(edges: seq[string]): CostMatrix =
    var memory = initTable[string, int]()
    var numberCities = 0

    var costs = newSeq[seq[int]]()

    for _, edge in edges[0 .. ^1]:
        var matches: array[3, string]

        discard edge.find(re"(\w+) to (\w+) = (\d+)", matches)
        
        # Converting keys to int
        for i in [0, 1]:
            if matches[i] notin memory:
                memory[matches[i]] = numberCities
                numberCities += 1
        
        let x = memory[matches[0]]
        let y = memory[matches[1]]
        let payload = parseInt(matches[2])

        costs.pushToMatrix(x, y, payload)
    
    return costs

# Brute forcing because why not?
# The number of expected inputs is low enough that it should be done in a couple of seconds
proc allPermutations(prefix: seq[int], missing: seq[int]): seq[seq[int]] =
    if missing.len == 0:
        return @[prefix]

    for elem in missing[0 .. ^1]:
        result.add(
            all_permutations(
                concat(prefix, @[elem]),
                missing.filterIt(it != elem)
            )
        )
    
    return result

proc getCost(costs: CostMatrix, permutation: seq[int]): int =
    var cost = 0
    
    for idx, elem in permutation[0 .. ^2]:
        let next = permutation[idx + 1]
        cost += costs[elem][next]
    
    return cost


let input = readFile("input.txt").split('\n')

let costs = makeCostMatrix(input)

# In theory, I could get away with fixing the first city for the distances
# but something went wrong when calculating the biggestDistance so
# let's do all of them
let distances = all_permutations(@[], toSeq(0..<costs.len))
    .map(p => costs.getCost(p))

let smallestDist = foldl(distances, min(a, b), high(int))
let biggestDist = foldl(distances, max(a, b), low(int))

echo "Part 1: ", smallestDist
echo "Part 2: ", biggestDist