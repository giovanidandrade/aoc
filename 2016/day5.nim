from std/md5 import getMD5
import std/strutils
import std/sequtils

proc firstNil(key: string, k: int, n: var int): string =
    var hash = getMD5(key & $n)
    let goal = repeat('0', k)

    while hash[0 .. (k - 1)] != goal:
        n += 1
        hash = getMD5(key & $n)
    
    return hash

let key = "cxdnnyjw"
var password = repeat('0', 8)

var n = 0
for idx in 0 ..< 8:
    let ch = firstNil(key, 5, n)[5]
    password[idx] = ch
    n += 1

echo "Part 1: ", password

echo "Part 2:\n"

n = 0
password = repeat('_', 8)
echo password

while password.filterIt(it == '_').len > 0:
    # Decrypting animation
    let hash = firstNil(key, 5, n)
    let pos = ord(hash[5]) - ord('0')
    
    if pos < 8 and password[pos] == '_':
        password[pos] = hash[6]
        echo password

    n += 1