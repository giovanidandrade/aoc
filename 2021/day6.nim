import std/strutils
import std/sequtils

type
    Ages = array[9, int]

proc makeAges(list: seq[int]): Ages =
    for i in 0 ..< 9:
        for elem in list:
            if elem == i:
                result[i] += 1
    
    return result

proc generation(ages: Ages): Ages =
    result = ages

    for i in 1 .. 8:
        result[i - 1] = result[i]
    
    let breedables = ages[0]
    result[6] += breedables
    result[8] = breedables

    return result

let input = readFile("input.txt").split(',').map(parseInt)

var gen = input.makeAges()
for _ in 1 .. 80:
    gen = gen.generation()

echo "Part 1: ", gen.foldl(a + b, 0)

for _ in 81 .. 256:
    gen = gen.generation()

echo "Part 2: ", gen.foldl(a + b, 0)