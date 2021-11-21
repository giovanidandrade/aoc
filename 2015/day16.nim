import std/tables
import std/strutils
import std/sequtils

type
    Information = Table[string, int]

let forensic = {
    "children": 3, "cats": 7, "samoyeds": 2,
    "pomeranians": 3, "akitas": 0, "vizslas": 0,
    "goldfish": 5, "trees": 3, "cars": 2,
    "perfumes": 1
}.toTable

proc makeInformation(description: string): Information =
    var info: Information
    var tokens = description.split(',')

    for elem in tokens[1 .. ^1]:
        let kv = elem.split(": ")

        info[kv[0].strip()] = kv[1].parseInt()
    
    # Getting rid of the Sue "n" prefix
    let kv = tokens[0].split(": ")
    info[kv[1].strip()] = kv[2].parseInt()

    return info

proc couldMatchOld(aunt: Information, info: Information): bool =
    for k, v in aunt:
        if info[k] != v:
            return false
    
    return true

proc couldMatch(aunt: Information, info: Information): bool =
    for k, v in aunt:
        if k in ["cats", "trees"]:
            if info[k] >= v:
                return false
        elif k in ["pomeranians", "goldfish"]:
            if info[k] <= v:
                return false
        elif info[k] != v:
            return false
    
    return true

let input = readFile("input.txt").split('\n').map(makeInformation)

for idx, aunt in input[0 .. ^1]:
    if aunt.couldMatchOld(forensic):
        echo "Part 1: ", idx + 1
        break

for idx, aunt in input[0 .. ^1]:
    if aunt.couldMatch(forensic):
        echo "Part 2: ", idx + 1
        break