from std/sequtils import mapIt, filterIt, concat
from std/strutils import join

proc decode(password: string): seq[int] =
    password.mapIt(ord(it) - ord('a'))

proc encode(password: seq[int]): string =
    password
        .mapIt(char(it + ord('a')))
        .mapIt($it)
        .join()

proc incPassword(password: seq[int]): seq[int] =
    result = password

    var index = password.len - 1
    var carry = 1

    while index >= 0 and carry > 0:
        let new_val = result[index] + carry

        carry = new_val div 26
        result[index] = new_val mod 26

        index -= 1
    
    # Since passwords must have eight chars, we'll be ignoring the 
    # carry out
    return result

proc hasThreeSeq(password: seq[int]): bool =
    for idx, elem in password[0 .. ^3]:
        let diff1 = password[idx + 1] - elem
        let diff2 = password[idx + 2] - elem

        if diff1 == 1 and diff2 == 2:
            return true
    
    return false

proc hasForbiddenLetters(password: seq[int]): bool =
    let letters = ['i', 'o', 'l'].mapIt(ord(it) - ord('a'))
    
    return password.filterIt(it in letters).len != 0

proc hasTwoNonOverlappingPairs(password: seq[int]): bool =
    var pairs: seq[seq[int]]

    for idx, elem in password[0 .. ^2]:
        if password[idx + 1] == elem and @[elem, elem] notin pairs:
            pairs.add(@[elem, elem])
    
    return pairs.len >= 2

proc findPassword(original: seq[int]): seq[int] =
    result = incPassword(original)

    while (not hasThreeSeq(result)) or
        hasForbiddenLetters(result) or
        (not hasTwoNonOverlappingPairs(result)):
            result = incPassword(result)
    
    return result

let input = readFile("input.txt")

let original = decode(input)
let next = findPassword(original)

echo "Part 1: ", next.encode()
echo "Part 2: ", findPassword(next).encode()