import std/re
import std/strutils
import std/sequtils

type
    IP = object
        hyper: seq[string]
        rest: seq[string]

proc hasSandwichedPair(str: string): bool =
    for idx in 0 .. (str.len - 4):
        let ch = str[idx]

        if str[idx + 3] == ch:
            let ch2 = str[idx + 1]
            if ch2 != ch and str[idx + 2] == ch2:
                return true
    
    return false

proc parseIP(str: string): IP =
    result.hyper = str.findAll(re"\[\w+\]").mapIt(it.strip(chars = {'[', ']'}))
    result.rest = str.replace(re"\[\w+\]", by = "-").split('-')

    return result

proc supportsTLS(ip: IP): bool =
    ip.rest.filter(hasSandwichedPair).len > 0 and
    ip.hyper.filter(hasSandwichedPair).len == 0

proc hasABA(str: string): seq[string] =
    for idx in 0 .. (str.len - 3):
        let ch = str[idx]

        if str[idx + 2] == ch:
            let ch2 = str[idx + 1]
            if ch2 != ch:
                result.add(ch & ch2 & ch)
    
    return result

proc hasBAB(str: string, abas: seq[string]): bool =
    for aba in abas[0 .. ^1]:
        let bab = aba[1] & aba[0] & aba[1]
        if str.contains(escapeRe(bab)):
            return true
    
    return false

proc supportsSSL(ip: IP): bool =
    var abas: seq[string]
    for str in ip.rest[0 .. ^1]:
        abas.add(
            str.hasABA()
        )

    if abas.len != 0:
        return ip.hyper.filterIt(hasBAB(it, abas)).len > 0

    return false

let input = readFile("input.txt").split("\n").map(parseIP)

echo "Part 1: ", input.filter(supportsTLS).len
echo "Part 2: ", input.filter(supportsSSL).len