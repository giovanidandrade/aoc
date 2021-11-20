from std/sequtils import map, filter
from std/strutils import split, parseUInt
import std/re
import std/sugar
import std/tables

type
    Environment = Table[string, uint16]

    Kind = enum buffer, andGate, orGate, notGate, lshift, rshift
    Connection = object
        kind: Kind
        ident: string
        lhs: string
        rhs: string
    
    Connections = seq[Connection]

proc makeConnection(kind: Kind, matches: array[3, string]): Connection =
    let ident = matches[2]
    let lhs = matches[0]
    let rhs = matches[1]

    return Connection(kind: kind, ident: ident, lhs: lhs, rhs: rhs)

proc `==`(this: Connection, that: Connection): bool =
    this.ident == that.ident

proc parseConnection(wiring: string): Connection =
    var matches: array[3, string]

    if wiring.contains(re"(\w+) AND (\w+) -> (\w+)", matches):
        return makeConnection(andGate, matches)

    if wiring.contains(re"(\w+) OR (\w+) -> (\w+)", matches):
        return makeConnection(orGate, matches)

    if wiring.contains(re"(\w+) LSHIFT (\w+) -> (\w+)", matches):
        return makeConnection(lshift, matches)

    if wiring.contains(re"(\w+) RSHIFT (\w+) -> (\w+)", matches):
        return makeConnection(rshift, matches)

    # Capturing the separator for the rhs
    # so we can preserve the structure
    if wiring.contains(re"NOT (\w+) (->) (\w+)", matches):
        return makeConnection(notGate, matches)

    # If we get here then we now we must be dealing with a buffer
    discard wiring.contains(re"(\w+) (->) (\w+)", matches)
    return makeConnection(buffer, matches)

proc findWire(env: var Environment, connections: Connections, wireName: string): uint16 =
    if wireName in env:
        return env[wireName]

    proc readValue(env: var Environment, ident: string): uint16 =
        try:
            return uint16(parseUInt(ident))
        except ValueError:
            return findWire(env, connections, ident)

    let connection = connections.filter(con => con.ident == wireName)[0]

    case connection.kind
    of buffer:
        env[connection.ident] = readValue(env, connection.lhs)
    of andGate:
        env[connection.ident] = readValue(env, connection.lhs) and readValue(env, connection.rhs)
    of orGate:
        env[connection.ident] = readValue(env, connection.lhs) or readValue(env, connection.rhs)
    of notGate:
        env[connection.ident] = not readValue(env, connection.lhs)
    of lshift:
        env[connection.ident] = readValue(env, connection.lhs) shl readValue(env, connection.rhs)
    of rshift:
        env[connection.ident] = readValue(env, connection.lhs) shr readValue(env, connection.rhs)
    
    return env[connection.ident]

var input = readFile("input.txt").split('\n').map(parseConnection)
var env = initTable[string, uint16]()

let oldResult = findWire(env, input, "a")

let newSignal = Connection(kind: buffer, ident: "b", lhs: $oldResult, rhs: " -> ")
let b_index = input.find(newSignal)

input[b_index] = newSignal

# Resetting the environment to recalculate stuff
env = initTable[string, uint16]()

echo "Part 1: ", oldResult
echo "Part 2: ", findWire(env, input, "a")



