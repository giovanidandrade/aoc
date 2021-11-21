import std/sequtils

proc allPermutations*(prefix: seq[int], missing: seq[int]): seq[seq[int]] =
    if missing.len == 0:
        return @[prefix]

    for elem in missing[0 .. ^1]:
        result.add(
            all_permutations(
                concat(prefix, @[elem]),
                missing.filterIt(it != elem)
            )
        )
    
    return result

proc maskCombinations*(n: int): seq[seq[bool]] =
    if n == 0:
        return @[]

    if n == 1:
        return @[
            @[true], @[false]
        ]

    let subcombinations = maskCombinations(n - 1)
    
    result.add(
        subcombinations.mapIt(
            @[true].concat(it)
        )
    )

    result.add(
        subcombinations.mapIt(
            @[false].concat(it)
        )
    )

    return result
    
