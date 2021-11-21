from std/strutils import parseInt
from std/sequtils import map, foldl
import std/re
import std/json

proc sumOfAllNumbersOld(input: string): int =
    let numbers = input.findAll(re"-?\d+")

    return numbers.map(parseInt).foldl(a + b, 0)

proc sumOfAllNumbers(input: JsonNode): BiggestInt =
    case input.kind
    of JString: return 0
    of JBool: return 0
    of JNull: return 0
    of JInt:
        return input.getInt()
    of JArray:
        for elem in input:
            result += sumOfAllNumbers(elem)
        
        return result
    of JObject:
        for key in input.keys():
            let val = input[key]

            if val.kind == JString and val.getStr() == "red":
                return 0

            result += sumOfAllNumbers(val)
        
        return result
    # We're assuming the JSON only has integers
    of JFloat: return 0
    

let input = readFile("input.txt")
let jsonNode = parseJson(input)

echo "Part 1: ", sumOfAllNumbersOld(input)
echo "Part 2: ", sumOfAllNumbers(jsonNode)