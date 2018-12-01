import math

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

echo "Solution: ", distance(347991)
