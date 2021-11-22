import std/strutils
import std/sequtils
import std/sugar

type
    Kind = enum hlf, tpl, inc, jmp, jie, ji1, ext

    Op = object
        kind: Kind
        lhs: string
        rhs: string
    
    Memory = object
        a: int
        b: int
        ip: int

proc makeOp(line: string): Op =
    let tokens = line
        .replace(",")
        .split(" ")
    
    result.kind = (case tokens[0]
    of "hlf": hlf
    of "tpl": tpl
    of "inc": inc
    of "jmp": jmp
    of "jie": jie
    of "jio": ji1
    else: ext)

    result.lhs = tokens[1]

    if tokens.len == 3:
        result.rhs = tokens[2]

proc binOp(mem: var Memory, register: string, op: int -> int) =
    if register == "a":
        mem.a = op(mem.a)
    else:
        mem.b = op(mem.b)

proc getRegister(mem: Memory, register: string): int =
    if register == "a":
        mem.a
    else:
        mem.b

proc defaultMem(): Memory = result

proc evalOps(ops: seq[Op], initMem = defaultMem()): Memory =
    result = initMem

    while result.ip < ops.len:
        let op = ops[result.ip]

        case op.kind
        of hlf:
            binOp(result, op.lhs, x => x div 2)
        of tpl:
            binOp(result, op.lhs, x => x * 3)
        of inc:
            binOp(result, op.lhs, x => x + 1)
        of jmp:
            let offset = parseInt(op.lhs)
            result.ip += offset
            continue
        of jie:
            if getRegister(result, op.lhs) mod 2 == 0:
                let offset = parseInt(op.rhs)
                result.ip += offset
                continue
        of ji1:
            if getRegister(result, op.lhs) == 1:
                let offset = parseInt(op.rhs)
                result.ip += offset
                continue
        of ext:
            break

        result.ip += 1
    
    return result

let input = readFile("input.txt").split("\n")

let ops = input.map(makeOp)

echo "Part 1: ", ops.evalOps().b
echo "Part 2: ", ops.evalOps(Memory(a: 1, b: 0, ip: 0)).b