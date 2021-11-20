from std/strutils import split, parseInt
from std/sequtils import mapIt, toSeq

proc rle(inp: seq[int]): seq[int] =
    assert(inp.len > 0)

    var elem = inp[0]
    var number_elems = 1
    
    if inp.len == 1:
        result.add([number_elems, elem])
        return result

    var index = 1
    while index < inp.len:
        if elem == inp[index]:
            number_elems += 1
        else:
            result.add([number_elems, elem])
            elem = inp[index]
            number_elems = 1
        
        index += 1
    
    result.add([number_elems, elem])
    return result

let input =  toSeq(readFile("input.txt")).mapIt(ord(it) - ord('0'))

var result = input
for _ in 0 ..< 40:
    result = rle(result)

echo "Part 1: ", result.len

for _ in 0 ..< 10:
    result = rle(result)

echo "Part 2: ", result.len