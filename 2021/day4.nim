import std/strutils
import std/sequtils

type
    Board = seq[seq[(int, bool)]]

proc parseBoards(dirs: seq[string]): seq[Board] =
    var temp: Board
    for line in dirs:
        if line == "":
            result.add(temp)
            temp = @[]
            continue

        let row = line
            .strip()
            .split(" ")
            .mapIt(it.strip())
            .filterIt(it != "")
            .mapIt((parseInt(it), false))
        
        temp.add(row)
    
    result.add(temp)
    return result

proc updateBoard(board: Board, num: int): Board =
    result = board
    for idx, row in board[0 .. ^1]:
        let jdx = row.find((num, false))
        if jdx != -1:
            let val = result[idx][jdx]
            result[idx][jdx] = (val[0], true)
            break

    return result

proc checkVictory(board: Board): bool =
    for row in board:
        let check = row
            .mapIt(it[1])
            .foldl(a and b, true)
        
        if check:
            return true
    
    for i in 0 ..< 5:
        var check = true
        for j in 0 ..< 5:
            check = check and board[j][i][1]
        
        if check:
            return true
    
    return false

proc getScore(board: Board, num: int): int =
    return num * board
        .mapIt(
            it.foldl(
                if not b[1]:
                    a + b[0]
                else:
                    a
                , 0
            )
        ).foldl(a + b, 0)

proc findFirstWinning(boards: seq[Board], rng: seq[int]): int =
    var temps = boards
    for num in rng:
        temps = temps.mapIt(
            updateBoard(it, num)
        )

        for board in temps:
            if board.checkVictory():
                return board.getScore(num)
    
    return -1

proc findLastWinning(boards: seq[Board], rng: seq[int]): int =
    var temps = boards
    for num in rng:
        temps = temps.mapIt(
            updateBoard(it, num)
        )

        if temps.len > 1:
            temps = temps.filterIt(not it.checkVictory())
        elif temps[0].checkVictory():
            return temps[0].getScore(num)
    
    return -1

let input = readFile("input.txt").split("\n")

let rng = input[0]
    .split(',')
    .map(parseInt)

let boards = input[2 .. ^1].parseBoards()

echo "Part 1: ", boards.findFirstWinning(rng)
echo "Part 2: ", boards.findLastWinning(rng)