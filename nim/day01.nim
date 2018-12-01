import strutils
import intsets

const data = readFile("./inputs/day01.txt")

# Part 1

var freq = 0

for line in data.splitLines():
    if line.strip() == "":
        continue
    freq = freq + parseInt(line)

echo "Solution 1: ", freq

# Part 2

var uniqueFreq : IntSet = initIntSet()
var should_loop_continue = true

freq = 0

while should_loop_continue:

    for line in data.splitLines():
        uniqueFreq.incl(freq)
        if line.strip() == "":
            continue
        freq = freq + parseInt(line)

        if freq in uniqueFreq:
            should_loop_continue = false
            break

echo "Solution 2: ", freq
