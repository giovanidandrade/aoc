import std/tables
import std/sugar

type
    Graph* = seq[seq[int]]
    Memory* = Table[string, int]
    GraphPayload* = object
        x*: int
        y*: int
        value*: int
        symmetric*: bool

proc pushToGraph*(matrix: var Graph, payload: GraphPayload) =
    let bound = max(payload.x, payload.y)

    while bound >= matrix.len:
        matrix.add(@[0])
    
    for idx, _ in matrix[0 .. ^1]:
        while bound >= matrix[idx].len:
            matrix[idx].add(0)
    
    let x = payload.x
    let y = payload.y

    matrix[x][y] = payload.value
    
    if payload.symmetric:
        matrix[y][x] = payload.value

## Given:
##    edges: a list of edges
##    parser: a proc that can parse an edge returning a GraphPayload
## 
## Returns:
##    an adjacency matrix of the described (non-directed) graph.
proc makeGraph*(edges: seq[string],
               parser: (string, var Memory, var int) -> GraphPayload): Graph =
    var memory = initTable[string, int]()
    var numberNodes = 0

    var graph = newSeq[seq[int]]()

    for _, edge in edges[0 .. ^1]:
        let payload = parser(edge, memory, numberNodes)
        graph.pushToGraph(payload)
    
    return graph