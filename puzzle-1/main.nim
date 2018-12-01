import strutils

const data = readFile("./puzzle-1/input.txt")

var freq = 0
for line in data.splitLines():
    if line.strip() == "":
        continue
    freq = freq + parseInt(line)

echo freq
