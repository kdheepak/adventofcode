import strutils

proc solve1(data: string): int =

    var s = 0

    for i, c in data:
        if (i == data.len - 1):
            if c == data[0]:
                s = s + parseInt($c)
        elif c == data[i + 1]:
            s = s + parseInt($c)

    return s

assert solve1("1122") == 3
assert solve1("1111") == 4
assert solve1("1234") == 0
assert solve1("91212129") == 9

const data = readFile("./inputs/day01.txt").strip()

echo "Solution1: ", solve1(data)

proc find_c(data: string, i: int): char =
    let l = data.len
    let mid = int(l / 2)
    if i < mid:
        return data[i + mid]
    else:
        return data[( i + mid ) - l]

proc solve2(data: string): int =

    var s = 0
    var cc = 'a'
    for i, c in data:
        cc = find_c(data, i)
        if c == cc:
            s = s + parseInt($c)

    return s

assert solve2("1212") == 6
assert solve2("1221") == 0
assert solve2("123425") == 4
assert solve2("123123") == 12
assert solve2("12131415") == 4

echo "Solution1: ", solve2(data)
