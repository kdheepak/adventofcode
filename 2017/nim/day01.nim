import strutils

proc solve(data: string): int =

    var s = 0

    for i, c in data:
        if (i == data.len - 1):
            if c == data[0]:
                s = s + parseInt($c)
        elif c == data[i + 1]:
            s = s + parseInt($c)

    return s

assert solve("1122") == 3
assert solve("1111") == 4
assert solve("1234") == 0
assert solve("91212129") == 9

const data = readFile("./inputs/day01.txt").strip()

echo "Solution1: ", solve(data)
