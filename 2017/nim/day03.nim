import math
import tables

proc distance(input: int) : int =
    if input == 1:
        return 0

    var size = 0

    if sqrt(float(input)) == round(sqrt(float(input))):
        size = int(floor(sqrt(float(input))))
        return size - 1

    size = int(floor(sqrt(float(input))))
    if (size mod 2) == 0:
        size = size - 1
    let inner_bottom_right = size * size
    let inner_bottom_left = inner_bottom_right - (size - 1)
    let inner_top_left = inner_bottom_left - (size - 1)
    let inner_top_right = inner_top_left - (size - 1)

    size = int(ceil(sqrt(float(input))))
    if (size mod 2) == 0:
        size = size + 1
    let outer_bottom_right = size * size
    let outer_bottom_left = outer_bottom_right - (size - 1)
    let outer_top_left = outer_bottom_left - (size - 1)
    let outer_top_right = outer_top_left - (size - 1)

    let mid = int((size - 1) / 2)
    var steps = 0
    if input <= outer_bottom_right and input >= outer_bottom_left:
        # echo "bottom"
        steps = steps + abs(input - (outer_bottom_left + mid))

    elif input <= outer_bottom_left and input >= outer_top_left:
        # echo "left "
        steps = steps + abs(input - (outer_top_left + mid))

    elif input <= outer_top_left and input >= outer_top_right:
        # echo "top"
        steps = steps + abs(input - (outer_top_right + mid))

    elif input <= outer_top_right and input >= inner_bottom_right + 1:
        # echo "right"
        steps = steps + abs(input - (inner_bottom_right + mid))

    else:
        echo "Cannot place number: ", $input
        return -1

    steps = steps + int( (size - 1) / 2 )
    # echo mid
    return steps

assert distance(12) == 3
assert distance(23) == 2
assert distance(1024) == 31
assert distance(101) == 10

const puzzle = 347991
echo "Solution1: ", distance(puzzle)

type Point = tuple[x: int, y: int]
var grid: Table[Point, int] = {(0, 0): 1}.toTable()

func neighbours(point: Point): array[8, Point] =
  let (x, y) = point
  return [
      (x+1, y),
      (x+1, y+1),
      (x, y+1),
      (x-1, y+1),
      (x-1, y),
      (x-1, y-1),
      (x, y-1),
      (x+1, y-1),
    ]


proc fill(point: Point): int =
    result = 0
    for neighbour in point.neighbours:
        result = result + grid.getOrDefault(neighbour)
    grid[point] = result


iterator proceed_in_spiral(): int =
  var step = 0
  while true:
    step = step + 1
    for y in countup( -step+1, step):
        yield fill((step,  y))
    for x in countdown(step-1, -step):
        yield fill((x,  step))
    for y in countdown(step-1, -step):
        yield fill((-step, y))
    for x in countup( -step+1, step):
        yield fill((x, -step))


for v in proceed_in_spiral():
    if v > puzzle:
        echo "Solution 2: ", v
        break



