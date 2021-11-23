import std/sequtils
import std/strutils

type Index = object
    base: int
    buf: seq[int]

proc makeIndex(base: int): Index = Index(base: base, buf: @[0])

proc inc(index: var Index) =
    var i = 1
    while i <= index.buf.len:
        index.buf[^i] += 1

        if index.buf[^i] == index.base:
            index.buf[^i] = 0
            i += 1
        else:
            break
    
    if i > index.buf.len:
        index.buf.add(0)

    if index.buf != index.buf.deduplicate():
        index.inc()

proc apply(sq: seq[int], index: Index): seq[int] =
    for idx in index.buf[0 .. ^1]:
        result.add(sq[idx])
    
    return result

proc quantumEntanglement(presents: seq[int], idx: var Index, numCompartments = 3): int =
    let bound = presents.len div 2
    let goal = presents.foldl(a + b, 0) div numCompartments

    while idx.buf.len <= bound:
        var qes: seq[int]

        let currentLen = idx.buf.len
        while idx.buf.len == currentLen:
            let subseq = presents.apply(idx)
            if subseq.foldl(a + b, 0) == goal:
                qes.add(
                    subseq.foldl(a * b, 1)
                )
            
            idx.inc()
        
        if qes.len != 0:
            return qes.foldl(min(a, b), high(int))
    
    return -1

let input = readFile("input.txt").split("\n").map(parseInt)

var idx = makeIndex(input.len)
echo "Part 1: ", input.quantumEntanglement(idx)

idx = makeIndex(input.len)
echo "Part 2: ", input.quantumEntanglement(idx, 4)