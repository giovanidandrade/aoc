import std/strutils
import std/re

proc decompress(input: string): string =
    var index = 0
    while index < input.len:
        let ch = input[index]
        
        if ch in Whitespace:
            index += 1

        elif ch == '(':
            var matches: array[2, string]
            if input.match(re"\((\d+)x(\d+)\)", matches, start = index):
                index += 3 + matches[0].len + matches[1].len

                let numChars = matches[0].parseInt()
                let numReps = matches[1].parseInt()

                let repeatee = input[index ..< index + numChars]

                for _ in 1 .. numReps:
                    result = result & repeatee
                
                index += numChars
            
            else:
                result = result & ch
                index += 1
        
        else:
            result = result & ch
            index += 1
    
    return result

proc decompressNew(input: string): int =

    var index = 0
    while index < input.len:
        let ch = input[index]
        
        if ch in Whitespace:
            index += 1

        elif ch == '(':
            var matches: array[2, string]
            if input.match(re"\((\d+)x(\d+)\)", matches, start = index):
                index += 3 + matches[0].len + matches[1].len

                let numChars = matches[0].parseInt()
                let numReps = matches[1].parseInt()

                let repeatee = input[index ..< index + numChars]

                result += numReps * decompressNew(repeatee)                
                index += numChars
            
            else:
                result += 1
                index += 1
        
        else:
            result += 1
            index += 1
    
    return result

let input = readFile("input.txt")

echo "Part 1: ", input.decompress().len
echo "Part 2: ", input.decompressNew()