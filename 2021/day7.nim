import std/strutils
import std/sequtils

proc alignment(positions: seq[int]): int =
    # Let's assume the ideal (integer) position
    # is bounded by the minimum and maximum position
    # of already existing crabs.

    var cost = high(int)
    for pos in positions:
        let alignment_cost = positions
            .mapIt(abs(it - pos))
            .foldl(a + b, 0)
        
        cost = min(cost, alignment_cost)
    
    return cost

proc alignmentNew(positions: seq[int]): int =
    # Let's assume the ideal (integer) position
    # is bounded by the minimum and maximum position
    # of already existing crabs.

    var cost = high(int)

    let minBound = positions[positions.minIndex()]
    let maxBound = positions[positions.maxIndex()]

    for pos in minBound .. maxBound:
        let alignment_cost = positions
            .mapIt(abs(it - pos))
            .mapIt((it * (it + 1)) div 2)
            .foldl(a + b, 0)
        
        cost = min(cost, alignment_cost)
    
    return cost

let input = readFile("input.txt").split(',').map(parseInt)

echo "Part 1: ", input.alignment()
echo "Part 2: ", input.alignmentNew()