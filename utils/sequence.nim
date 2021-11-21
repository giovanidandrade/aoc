# Flattens a seq of seq by one level
proc flatten*[T](list: seq[seq[T]]): seq[T] =
    for sublist in list[0 .. ^1]:
        result.add(sublist)
    
    return result