import std/sequtils
import std/strutils
import std/sugar
import std/re

proc numberVowels(input: string): int =
    let vowels = input.filter(ch => ch in "aeiou")
    return foldl(vowels, a + 1, 0)

proc hasDoubleLetter(input: string): bool =
    for _, ch in input[0 .. ^1]:
        if (ch & ch) in input:
            return true
    
    return false

proc hasForbiddenSubstring(input: string): bool =
    let substrings = ["ab", "cd", "pq", "xy"]
    for _, substring in substrings[0 .. ^1]:
        if substring in input:
            return true
    
    return false

proc numberNiceStringsOld(lines: seq[string]): int =
    let isNice = lines.map(
        input => numberVowels(input) >= 3 and
        hasDoubleLetter(input) and
        (not hasForbiddenSubstring(input))
    ).map(b => int(b))

    return foldl(isNice, a + b, 0)

proc hasNonOverlappingPair(input: string): bool =
    for idx, ch in input[0 .. ^2]:
        let next_ch = input[idx + 1]

        let pair = ch & next_ch
        let pattern = re(pair & ".*" & pair)

        if input[idx .. ^1].contains(pattern):
            return true
    
    return false

proc hasSandwichedLetter(input: string): bool =
    for idx, ch in input[0 .. ^1]:
        let pattern = re(ch & '.' & ch)
        
        if input[idx .. ^1].contains(pattern):
            return true
    
    return false

proc numberNiceStrings(lines: seq[string]): int =
    let isNice = lines.map(
        input => hasNonOverlappingPair(input) and hasSandwichedLetter(input)
    ).map(b => int(b))

    return foldl(isNice, a + b, 0)

let input = readFile("input.txt").split('\n')

echo "Part 1: ", numberNiceStringsOld(input)
echo "Part 2: ", numberNiceStrings(input)