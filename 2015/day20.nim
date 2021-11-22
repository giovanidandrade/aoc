from std/strutils import parseInt
from std/sequtils import foldl, repeat
from std/math import sqrt, ceil
import std/tables

proc divisors(n: int): seq[int] =
    result = @[1]

    let sqrtN = n.float().sqrt().ceil().int()
    for k in 2 ..< sqrtN:
        if n mod k == 0:
            result.add(k)

            let divK = n div k
            if divK != k:            
                result.add(n div k)
    
    if n != 1:
        result.add(n)

    return result

proc lazyElves(goal: int): int =
    let bound = goal div 11
    var buffer = initTable[int, int]()

    for elf in 1 .. bound:
        for house in 1 .. 50:
            let index = house * elf - 1
            buffer[index] = buffer.getOrDefault(index) + 11 * elf
        
        if buffer[elf - 1] >= goal:
            return elf


# Dividing by 10 because the problem statement says elves gives 10 
# presents per house
let numGifts = readFile("input.txt").parseInt()

var n = 1
while n.divisors().foldl(a + b, 0) < numGifts div 10:
    n += 1

echo "Part 1: ", n
echo "Part 2: ", lazyElves(numGifts)
