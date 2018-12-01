import strutils
import intsets

const data = readFile("./puzzle-1/input.txt")

var freq = 0
var uniqueFreq : IntSet = initIntSet()

var should_loop_continue = true

while should_loop_continue:

    for line in data.splitLines():
        uniqueFreq.incl(freq)
        if line.strip() == "":
            continue
        freq = freq + parseInt(line)

        if freq in uniqueFreq:
            should_loop_continue = false
            break


echo freq
