import std/strutils
import std/sequtils
import std/algorithm
import std/sugar

discard """
 aaaa
b    c
b    c
 dddd
e    f
e    f
 gggg
"""

proc intersect[T](a: seq[T], b: seq[T]): seq[T] =
    for elem in a:
        if elem in b:
            result.add(elem)
    
    return result

proc diff[T](a: seq[T], b: seq[T]): seq[T] =
    for elem in a:
        if elem notin b:
            result.add(elem)
    
    return result

proc decode(line: string): (seq[int], seq[int]) =
    let tokens = line.split('|')

    var input = tokens[0].strip().split(' ')
    var output = tokens[1].strip().split(' ')

    for idx, _ in input[0 .. ^1]:
        input[idx].sort()
    
    for idx, _ in output[0 .. ^1]:
        output[idx].sort()
    
    result[0] = repeat(0, input.len)
    result[1] = repeat(0, output.len)

    var one: seq[char]
    var four: seq[char]
    var seven: seq[char]
    for idx, elem in input[0 .. ^1]:
        # First we identify the easy ones
        if elem.len == 2:
            one = elem.items.toSeq()
            result[0][idx] = 1
        
        elif elem.len == 3:
            seven = elem.items.toSeq()
            result[0][idx] = 7
        
        elif elem.len == 4:
            four = elem.items.toSeq()
            result[0][idx] = 4
        
        elif elem.len == 7:
            result[0][idx] = 8
    
    let L = four.diff(one)
    for idx, elem in input[0 .. ^1]:
        if elem.len == 5 and elem.items.toSeq().intersect(one).len == 2:
            result[0][idx] = 3
        
        elif elem.len == 5 and elem.items.toSeq().intersect(L).len == 2:
            result[0][idx] = 5
        
        elif elem.len == 5:
            result[0][idx] = 2
        
        elif elem.len == 6 and elem.items.toSeq().intersect(one).len != 2:
            result[0][idx] = 6
        
        elif elem.len == 6 and elem.items.toSeq().intersect(L).len == 2:
            result[0][idx] = 9
        
        # 0 is default so we don't need to set it
    
    for idx in 0 .. 3:
        for jdx, elem in input[0 .. ^1]:
            if output[idx] == input[jdx]:
                result[1][idx] = result[0][jdx]
                break

    return result

let input = readFile("input.txt")
    .split("\n")
    .map(decode)

echo "Part 1: ", input
    .map(tp => tp[1].filterIt(it in @[1, 4, 7, 8]).len)
    .foldl(a + b, 0)

echo "Part 2: ", input
    .map(tp => tp[1]
        .mapIt(char(it + int('0')))
        .join("")
        .parseInt()
    )
    .foldl(a + b, 0)