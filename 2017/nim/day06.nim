import strutils
import sets

type
  Part = enum
    pPart1, pPart2

const data = @[4, 10, 4, 1, 8, 4, 9, 14, 5, 1, 14, 15, 0, 15, 3, 5]
# const data = @[0, 2, 7, 0]

proc find_largest(data: seq[int]): int =
    return data.find(max(data))

proc toString(data: seq[int]): string =
    for ch in data:
        add(result, $ch)
        add(result, ",")

proc redistribute(data: seq[int], part: Part): int =

    var blocks = data
    var seen_blocks = initSet[string]()

    while not seen_blocks.contains(blocks.toString):

        seen_blocks.incl blocks.toString
        var pos = find_largest(blocks)
        var memory = blocks[pos]
        blocks[pos] = 0
        while memory > 0:
            pos = pos + 1
            if pos >= data.len:
                pos = 0
            blocks[pos] = blocks[pos] + 1
            memory = memory - 1

        result = result + 1
        # echo seen_blocks

    if part == pPart2:
        return redistribute(blocks, pPart1)
    else:
        return result

echo redistribute(data, part = pPart1)

echo redistribute(data, part = pPart2)
