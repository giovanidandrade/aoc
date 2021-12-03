import std/strutils
import std/sequtils
from std/bitops import fastLog2, bitsliced

proc getGammaEps(numbers: seq[int], numBits: int): int =
    var counter = repeat(
        0, numBits
    )

    for n in numbers:
        var idx = counter.len - 1
        var k = n
        while idx >= 0:
            if (k and 1) > 0:
                counter[idx] += 1
            
            k = k shr 1
            idx -= 1

    let common = counter
        .mapIt(int(it > numbers.len div 2))
        .foldl(a * 2 + b, int(0))

    let notCommon = (not common)
        .bitsliced(
            0 ..< numBits
        )
    
    return common * notCommon

proc getOxyGen(numbers: seq[int], bitPos: int): int =
    if numbers.len == 1:
        return numbers[0]

    var counterOne = 0
    var counterZero = 0
    for n in numbers:
        if n.bitsliced(bitPos .. bitPos) == 1:
            counterOne += 1
        else:
            counterZero += 1
    
    let chosenBit = int(counterOne >= counterZero)
    let nextVals = numbers
        .filterIt(
            it.bitsliced(bitPos .. bitPos) ==
            chosenBit
        )
    
    return getOxyGen(nextVals, bitPos - 1)

proc getCO2Scrub(numbers: seq[int], bitPos: int): int =    
    if numbers.len == 1:
        return numbers[0]

    var counterOne = 0
    var counterZero = 0
    for n in numbers:
        if n.bitsliced(bitPos .. bitPos) == 1:
            counterOne += 1
        else:
            counterZero += 1
    
    let chosenBit = int(counterZero > counterOne)
    let nextVals = numbers
        .filterIt(
            it.bitsliced(bitPos .. bitPos) ==
            chosenBit
        )
    
    return getCO2Scrub(nextVals, bitPos - 1)

let input = readFile("input.txt")
    .split('\n')
    .map(parseBinInt)

let numBits = input
    .foldl(max(a, b), low(int))
    .fastLog2() + 1

echo "Part 1: ", input.getGammaEps(numBits)
echo "Part 2: ", input.getOxyGen(numBits - 1) * input.getCO2Scrub(numBits - 1)