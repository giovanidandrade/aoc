let row = 3010
let column = 3019

proc makeNthCode(n: int): int =
    let multiplier = 252533
    let modulo = 33554393

    result = 20151125
    for k in 1 .. (n - 1):
        result = (result * multiplier) mod modulo
    
    return result

proc getIndex(row: int, column: int): int =
    # [row, 0] is T(row - 1) + 1
    result = 1
    for n in 1 ..< row:
        result += n    
    
    var offset = 0
    for n in 1 ..< column:
        offset += row + n

    result += offset
        
    return result

echo "Part 1: ", getIndex(row, column).makeNthCode()