import std/strutils
import std/sequtils
import std/algorithm

let input = readFile("input.txt").split("\n")

proc getPoints(line: string): (int, seq[char]) =
    var stack: seq[char]

    for ch in line:
        if ch in "([{<":
            stack.add(ch)
        
        else:
            let popped = stack.pop()
            case ch
            of ')':
                if popped != '(':
                    return (3, stack)
            of ']':
                if popped != '[':
                    return (57, stack)
            of '}':
                if popped != '{':
                    return (1197, stack)
            of '>':
                if popped != '<':
                    return (25137, stack)
            else:
                discard
    
    # If we get here it's incomplete
    return (0, stack)

proc autoComplete(sq: seq[char]): int =
    var stack = sq
    while stack.len != 0:
        let ch = stack.pop()
        
        result *= 5
        case ch
        of '(': result += 1
        of '[': result += 2
        of '{': result += 3
        of '<': result += 4
        else: discard
    
    return result

let points = input.map(getPoints)

echo "Part 1: ", points.foldl(a + b[0], 0)

var autoScore = points.filterIt(it[0] == 0).mapIt(it[1].autoComplete)
sort(autoScore)

echo "Part 2: ", autoScore[autoScore.len div 2]