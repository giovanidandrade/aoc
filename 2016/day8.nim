import std/sequtils
import std/strutils

type
    Screen = seq[seq[bool]]

let WIDTH = 50
let HEIGHT = 6

proc makeScreen(): Screen =
    repeat(
        repeat(false, WIDTH),
        HEIGHT
    )

proc printScreen(screen: Screen) =
    for row in screen:
        var str = ""
        for pixel in row:
            if pixel:
                str = str & "#"
            else:
                str = str & "."
        
        echo str

proc drawRect(screen: Screen, width: int, height: int): Screen =
    result = screen

    for y in 0 ..< height:
        for x in 0 ..< width:
            result[y][x] = true
    
    return result

proc rotateCol(screen: Screen, column: int, offset: int): Screen =
    result = screen
    for y in 0 ..< HEIGHT:
        let offset_idx = (y + offset) mod HEIGHT
        result[offset_idx][column] = screen[y][column]
    
    return result

proc rotateRow(screen: Screen, row: int, offset: int): Screen =
    result = screen
    for x in 0 ..< WIDTH:
        let offset_idx = (x + offset) mod WIDTH
        result[row][offset_idx] = screen[row][x]
    
    return result

proc parseCommand(screen: Screen, command: string): Screen =
    if command.startsWith("rect"):
        let tokens = command["rect ".len .. ^1]
            .split("x")
            .map(parseInt)
        
        return screen.drawRect(
            tokens[0],
            tokens[1]
        )
    elif command.startsWith("rotate row y="):
        let tokens = command["rotate row y=".len .. ^1]
            .split(" by ")
            .map(parseInt)
        
        return screen.rotateRow(
            tokens[0],
            tokens[1]
        )
    else:
        let tokens = command["rotate column x=".len .. ^1]
            .split(" by ")
            .map(parseInt)
        
        return screen.rotateCol(
            tokens[0],
            tokens[1]
        )


let input = readFile("input.txt").split("\n")
var screen = makeScreen()
for cmd in input:
    screen = screen.parseCommand(cmd)

echo "Part 1: ", screen
    .mapIt(it.foldl(a + int(b), 0))
    .foldl(a + b, 0)

echo "Part 2:"
screen.printScreen()