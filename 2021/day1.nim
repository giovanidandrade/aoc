import std/strutils
import std/sequtils

proc posDiff(sq: seq[int]): int =
    for idx, elem in sq[1 .. ^1]:
        if elem - sq[idx] > 0:
            result += 1
    
    return result

proc movingSum(sq: seq[int]): seq[int] =
    for idx, elem in sq[1 .. ^2]:
        let sum = sq[idx] + elem + sq[idx + 2]
        result.add(sum)
    
    return result

let input = readFile("input.txt")
    .split("\n")
    .map(parseInt)

echo "Part 1: ", input.posDiff()
echo "Part 2: ", input.movingSum().posDiff()