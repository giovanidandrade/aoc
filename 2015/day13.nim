from std/strutils import parseInt, split
from std/sequtils import toSeq
import ../utils/graph
import ../utils/permutations
import std/re
import std/tables

proc parser(edge: string, memory: var Memory, numberNodes: var int): GraphPayload =
    var matches: array[4, string]

    discard edge.find(
        re"(\w+) would (gain|lose) (\d+) happiness units by sitting next to (\w+)", matches)
    
    # Converting keys to int
    for i in [0, 3]:
        if matches[i] notin memory:
            memory[matches[i]] = numberNodes
            numberNodes += 1
    
    var payload = matches[2].parseInt()
    if matches[1] == "lose":
        payload *= -1
    
    let x = memory[matches[0]]
    let y = memory[matches[3]]

    return GraphPayload(x: x, y: y, value: payload, symmetric: false)

proc findHappiestArrangement(happinessMatrix: Graph, permutations: seq[seq[int]]): int =
    result = low(int)

    for permutation in permutations[0 .. ^1]:
        var happiness = 0

        for idx, elem in permutation[0 .. ^2]:
            let next = permutation[idx + 1]
            happiness += happinessMatrix[elem][next] + happinessMatrix[next][elem]
        
        # Closing the cycle
        let first = permutation[0]
        let last = permutation[^1]

        happiness += happinessMatrix[last][first] + happinessMatrix[first][last]

        result = max(result, happiness)
    
    return result

let input = readFile("input.txt").split('\n')


var happinessMatrix = makeGraph(input, parser)
var numberNodes = happinessMatrix.len
var arrangements = allPermutations(@[], toSeq(0..<numberNodes))

echo "Part 1: ", happinessMatrix.findHappiestArrangement(arrangements)

# Adding myself
for node in 0 ..< numberNodes:
    let payload = GraphPayload(x: node, y: numberNodes + 1, value: 0, symmetric: true)
    happinessMatrix.pushToGraph(payload)

numberNodes += 1

# There's probably a more sophisticated way to create the new arrangement
# but I'm too tired to deal with that right now
arrangements = allPermutations(@[], toSeq(0..<numberNodes))

echo "Part 2: ", happinessMatrix.findHappiestArrangement(arrangements)