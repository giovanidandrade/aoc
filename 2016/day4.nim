import std/strutils
import std/sequtils
import std/algorithm
import std/sugar

type
    Room = object
        crypto: string
        id: int
        checksum: string
    
    Pair[T] = object
        n: int
        v: T

proc makeRoom(description: string): Room =
    let tokens = description.split('-')

    let idChecksum = tokens[^1].split('[')

    result.crypto = tokens[0 .. ^2].toSeq().join("-")
    result.id = idChecksum[0].parseInt()
    result.checksum = idChecksum[1].strip(chars = {']'})

    return result

proc rle[T](inp: seq[T]): seq[Pair[T]] =
    assert(inp.len > 0)

    var elem = inp[0]
    var number_elems = 1
    
    if inp.len == 1:
        result.add(
            [Pair[T](n: number_elems, v: elem)]
        )
        return result

    var index = 1
    while index < inp.len:
        if elem == inp[index]:
            number_elems += 1
        else:
            result.add(
                [Pair[T](n: number_elems, v: elem)]
            )
            elem = inp[index]
            number_elems = 1
        
        index += 1
    
    result.add(
        [Pair[T](n: number_elems, v: elem)]
    )
    return result

proc isDecoy(room: Room): bool =
    let checksum = room
        .crypto
        .replace("-")
        .sorted()
        .rle()
        .sorted(
            cmp = (x: Pair[char], y: Pair[char]) => (
                if cmp(x.n, y.n) == 0:
                    cmp(x.v, y.v)
                else:
                    -cmp(x.n, y.n)
            )
        )
        .mapIt(it.v)[0 .. 4]
    
    return checksum.join("") != room.checksum

proc decrypt(room: Room): string =
    let offset = room.id mod 26

    let tokens = room
        .crypto
        .split('-')
    
    for token in tokens[0 .. ^1]:
        let plainToken = token
            .mapIt(ord(it) - ord('a'))
            .mapIt((it + offset) mod 26)
            .mapIt(char(it + ord('a')))
            .join("")
        
        result = result & plainToken & " "
    
    return result.strip()

let input = readFile("input.txt")
    .split("\n")
    .mapIt(makeRoom(it))

let notDecoys = input
    .filterIt(not isDecoy(it))

echo "Part 1: ", notDecoys.foldl(a + b.id, 0)
echo "Part 2: ", notDecoys
    .filterIt(decrypt(it) == "northpole object storage")[0]
    .id