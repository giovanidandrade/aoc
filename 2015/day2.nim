from std/strutils import split, parseInt
from std/sequtils import map

type
    Box = object
        length: int
        width: int
        height: int

proc biggest_side(box: Box): int =
    max(box.length, max(box.width, box.height))

proc parseBox(description: string): Box =
    let values = split(description, 'x').map(parseInt)
    assert(values.len == 3)

    return Box(length: values[0], width: values[1], height: values[2])

proc calculatePaperArea(boxes: seq[Box]): int =
    var area = 0

    for _, box in boxes[0 .. ^1]:
        let surface_area = 
            2 * (box.length * box.width + box.width * box.height + box.height * box.length)
        
        let slack = box.length * box.width * box.height div box.biggest_side()

        area += surface_area + slack

    return area

proc calculateRibbonLength(boxes: seq[Box]): int =
    var length = 0

    for _, box in boxes[0 .. ^1]:
        let bow_length = box.length * box.width * box.height

        let side_length = 2 * (box.length + box.width + box.height - box.biggest_side())

        length += bow_length + side_length

    return length

let input = readFile("input.txt").split('\n').map(parseBox)

echo "Part 1: ", calculatePaperArea(input), " ft²"
echo "Part 2: ", calculateRibbonLength(input), " ft"