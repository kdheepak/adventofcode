import sequtils
import strutils

const data = readFile("./inputs/day02.txt").strip()


proc checksum(data: string): int =
    var twos = 0
    var threes = 0
    var number_of_twos = 0
    var number_of_threes = 0
    for line1 in data.split():
        number_of_twos = 0
        number_of_threes = 0
        for c1 in line1:
            if line1.count(c1) == 2:
                number_of_twos += 1
            if line1.count(c1) == 3:
                number_of_threes += 1
        if number_of_twos > 0:
            twos += 1
        if number_of_threes > 0:
            threes += 1
    return twos * threes

echo checksum(data)

proc find_closest_match(data: string) =

    for line1 in data.split():
        for line2 in data.split():
            var found_diff = 0
            for c in zip(line1, line2):
                let ( c1, c2 ) = c
                let s = abs(ord(c1) - ord(c2))
                if s == 0:
                    continue
                if s != 0:
                    found_diff += 1
            if found_diff == 1:
                for c in zip(line1, line2):
                    let ( c1, c2 ) = c
                    if c1 == c2:
                        stdout.write(c1)
                echo ""
                return

find_closest_match(data)
