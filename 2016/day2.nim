import std/strutils
import std/sequtils
import std/sugar

type
    Direction = enum up, down, left, right, invalid
    Shifts = array[up .. right, seq[int]]

let simpleShifts: Shifts = [
    @[1, 2, 3, 1, 2, 3, 4, 5, 6], #up
    @[4, 5, 6, 7, 8, 9, 7, 8, 9], # down
    @[1, 1, 2, 4, 4, 5, 7, 7, 8], # left
    @[2, 3, 3, 5, 6, 6, 8, 9, 9]  # right
]

let hardShifts: Shifts = [
    @[      1,
         2, 1, 4,
      5, 2, 3, 4, 9,
         6, 7, 8,
           11
    ], # up
    @[      3,
         6, 7, 8,
      5,10,11,12, 9,
        10,13,12,
           13
    ], # down
    @[      1,
         2, 2, 3,
      5, 5, 6, 7, 8,
        10,10,11,
           13
    ], # left
    @[      1,
         3, 4, 4,
      6, 7, 8, 9, 9,
        11,12,12,
           13
    ], # right
]

proc makeDirection(input: char): Direction =
    case input
    of 'U': up
    of 'D': down
    of 'L': left
    of 'R': right
    else: invalid

proc getKey(commands: string, current: var int, numpad = simpleShifts): int =
    for ch in commands[0 .. ^1]:
        let dir = ch.makeDirection()
        current = numpad[dir][current - 1]
    
    return current

let input = readFile("input.txt").split("\n")

var key = 5
echo "Part 1: ", input.map(cmd => cmd.getKey(key))

key = 5
echo "Part 2: ", input.map(cmd => cmd.getKey(key, hardShifts))
    .mapIt(
        if it < 10:
            char(it + ord('0'))
        else:
            char(it - 10 + ord('A'))
    )