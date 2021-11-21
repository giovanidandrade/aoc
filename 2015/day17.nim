import std/strutils
import std/sequtils
import std/sugar
import ../utils/permutations

proc testMask(mask: seq[bool], containers: seq[int], volume: int): bool =
    assert(mask.len == containers.len)

    var sum = 0
    for idx, elem in containers:
        if mask[idx]:
            sum += elem
    
    return sum == volume

proc checkAndUpdate(mask: seq[bool], containers: seq[int], volume: int, smallest: var int): int =
    let numContainers = mask.filterIt(it).foldl(a + 1, 0)
    result = int(mask.testMask(containers, volume))
    if result == 1 and numContainers < smallest:
        smallest = numContainers
    
    return result

let input = readFile("input.txt").split('\n').map(parseInt)
let masks = maskCombinations(input.len)

var smallest = high(int)

echo "Part 1: ", masks
    .map((mask: seq[bool]) => (
        let numContainers = mask.filterIt(it).foldl(a + 1, 0)
        result = int(mask.testMask(input, 150))
        if result == 1 and numContainers < smallest:
            smallest = numContainers
    
        return result
    ))
    .foldl(a + b, 0)

echo "Part 2: ", masks
    .filter((mask: seq[bool]) => (
        let setBits = mask.filterIt(it).foldl(a + 1, 0)
        return setBits == smallest
    ))
    .map((mask: seq[bool]) => int(mask.testMask(input, 150)))
    .foldl(a + b, 0)