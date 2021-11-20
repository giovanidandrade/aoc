from std/strutils import split, escape, unescape
from std/sequtils import map, foldl
import std/sugar

let input = readFile("input.txt").split('\n')

let memDiffs = input.map(str => str.len - unescape(str).len)
let finalDiffs = input.map(str => escape(str).len - str.len)

echo "Part 1: ", foldl(memDiffs, a + b, 0)
echo "Part 2: ", foldl(finalDiffs, a + b, 0)