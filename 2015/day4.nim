from std/md5 import getMD5
from std/strutils import repeat

proc firstNil(key: string, k: int): int =
    var n = 1

    var hash = getMD5(key & $n)
    let goal = repeat('0', k)

    while hash[0 .. (k - 1)] != goal:
        n += 1
        hash = getMD5(key & $n)
    
    return n


let input = readFile("input.txt")

echo "Part 1: ", firstNil(input, 5)
echo "Part 2: ", firstNil(input, 6)