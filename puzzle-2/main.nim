import strutils

const data = readFile("./puzzle-1/input.txt")

var freq = 0
var uniqueFreq : seq[int]

var should_loop_continue = true

while should_loop_continue:

    for line in data.splitLines():
        uniqueFreq.add(freq)
        if line.strip() == "":
            continue
        freq = freq + parseInt(line)

        if freq in uniqueFreq:
            should_loop_continue = false
            break


echo freq
