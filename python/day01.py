
with open("./inputs/day01.txt") as f:
    data = f.read()

# Part 1

freq = 0

for line in data.split():
    if line.strip() == "":
        continue
    freq = freq + int(line)

print( "Solution 1: ", freq )

# Part 2

uniqueFreq = set()
should_loop_continue = True

freq = 0

while should_loop_continue:

    for line in data.split():
        uniqueFreq.add(freq)
        if line.strip() == "":
            continue
        freq = freq + int(line)

        if freq in uniqueFreq:
            should_loop_continue = False
            break

print( "Solution 2: ", freq )
