import std/strutils
import std/sequtils
import std/re

proc isTriangle(sides: seq[int]): bool =
    let sum = sides.foldl(a + b, 0)
    for side in sides[0 .. ^1]:
        if sum <= 2 * side:
            return false
    
    return true

proc readVertical(lines: seq[string]): seq[seq[int]] =
    result = newSeq[seq[int]]()

    let startNumber = re"^\s*\d+"
    var copy = lines
    for column in 0 .. 2:
        

        for idx in countup(0, lines.len - 1, 3):
            var subseq = newSeq[int](3)
            for k in 0 .. 2:
                subseq[k] = copy[idx + k]
                    .findAll(startNumber)[0]
                    .strip()
                    .parseInt()
                
                copy[idx + k] = copy[idx + k]
                    .replace(startNumber)
        
            result.add(subseq)
    
    return result


let input = readFile("input.txt")
    .split("\n")

let horizontal = input
    .mapIt(
        it
        .findAll(re"\d+")
        .map(parseInt)
    )

echo "Part 1: ", horizontal.filter(isTriangle).len
echo "Part 2: ", input.readVertical().filter(isTriangle).len