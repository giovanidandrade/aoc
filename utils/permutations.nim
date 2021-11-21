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