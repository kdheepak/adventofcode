import sugar
import algorithm
import sequtils

const SIZE = 5
const PUZZLE = @[3, 4, 1, 5]

type
    Algorithm = object
        clist: seq[int]
        current_position: int
        skip_size: int
        lengths: seq[int]

proc initAlgorithm(): Algorithm =
    let x = lc[x | (x <- 0..<SIZE), int]
    return Algorithm(clist: x, current_position: 0, skip_size: 0, lengths: PUZZLE)

var a = initAlgorithm()

proc reverse(a: var Algorithm) =
    start_idx = a.current_position
    end_idx = a.lengths[0]
    a.clist[..<a.lengths[0]] = reversed[int]( a.clist[a.current_position..<a.lengths[0]] )

    a.current_position = a.lengths[0] + a.skip_size
    a.skip_size = a.skip_size + 1

    a.lengths.delete(0, 0)

    echo a.clist


a.reverse()
