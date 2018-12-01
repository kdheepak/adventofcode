import strutils
import sugar
import math

proc checksum(data: string): int =

    var cs: int

    for l in data.splitLines():
        var max_v = 0
        var min_v = high(int)
        for v in l.split(seps={'\t'}):
            let iv = parseInt(v)
            max_v = max(iv, max_v)
            min_v = min(iv, min_v)
        cs = cs + max_v - min_v
    return cs

proc evenly_divisible(data: string): int =

    var ed: int

    for l in data.splitLines():
        let sv = lc[parseInt(v) | (v <- l.split(seps={'\t'})), int]
        for i, v1 in sv:
            for j, v2 in sv:
                if i == j:
                    continue
                if round(v1 / v2) == v1 / v2:
                    ed = ed + int(v1 / v2)
    return ed

const data = readFile("./inputs/day02.txt").strip()

echo checksum(data)
echo evenly_divisible(data)
