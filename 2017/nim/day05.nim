import strutils

type
  Part = enum
    pPart1, pPart2

proc parse(data: string): seq[int] =
    for l in data.splitLines():
        let number = parseInt(l)
        result.add(number)

proc valid_jumps(data: seq[int], part: Part): int =
    var arr = data
    var index = 0
    let length = arr.len
    try:
        while true:
            let jump = arr[index]
            result = result + 1
            if jump >= 3 and part == pPart2:
                arr[index] = arr[index] - 1
            else:
                arr[index] = arr[index] + 1
            index = index + jump
    except:
        discard

const data = readFile("./inputs/day05.txt").strip()

# echo valid_jumps(@[0, 3, 0, 1, -3])

echo "Solution1: ", valid_jumps(data.parse, pPart1)
echo "Solution2: ", valid_jumps(data.parse, pPart2)

