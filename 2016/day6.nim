import std/strutils
import std/tables

let input = readFile("input.txt").split("\n")

var correctCode = ""
var correctestCode = ""
for idx in 0 ..< input[0].len:
    var mem = initTable[char, int]()

    for line in input[0 .. ^1]:
        let ch = line[idx]
        mem[ch] = mem.getOrDefault(ch) + 1
    
    var frequencyHigh = low(int)
    var mostFrequent: char

    var frequencyLow = high(int)
    var leastFrequent: char
    for k, v in mem:
        if v > frequencyHigh:
            mostFrequent = k
            frequencyHigh = v
        
        if v < frequencyLow:
            leastFrequent = k
            frequencyLow = v

    correctCode = correctCode & mostFrequent
    correctestCode = correctestCode & leastFrequent

echo "Part 1: ", correctCode
echo "Part 2: ", correctestCode