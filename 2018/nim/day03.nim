import strutils
import tables

const data = readFile("./inputs/day03.txt").strip()

# data = """#1 @ 1,3: 4x4
# #2 @ 3,1: 4x4
# #3 @ 5,5: 2x2"""

type Point = tuple[x: int, y: int]

var grid : Table[Point, int] = {(0, 0): 0}.toTable()

for l in data.strip().splitlines():
    let line = l.split()
    let
        id = line[0]
        coord = line[2].replace(":", "")
        size = line[3]
    let c = coord.split(",")
    let
        x = c[0].parseInt
        y = c[1].parseInt
    let s = size.split("x")
    let
        width = s[0].parseInt
        height = s[1].parseInt
    for i in (x ..< x + width):
        for j in (y ..< y + height):
            grid[(i, j)] = grid.getOrDefault((i, j), 0) + 1

var count = 0
for k, v in grid:
    if v >= 2:
        count = count + 1

echo count


for l in data.strip().splitlines():
    let line = l.split()
    let
        id = line[0]
        coord = line[2].replace(":", "")
        size = line[3]
    let c = coord.split(",")
    let
        x = c[0].parseInt
        y = c[1].parseInt
    let s = size.split("x")
    let
        width = s[0].parseInt
        height = s[1].parseInt
    var is_overlap = false
    for i in (x ..< x + width):
        for j in (y ..< y + height):
            if grid[(i, j)] != 1:
                is_overlap = true
    if is_overlap == false:
        echo id
        break



