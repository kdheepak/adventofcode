using DataStructures

puzzle_input = "134792-675810"

lower, upper = split(puzzle_input, "-")
lower, upper = parse(Int, lower), parse(Int, upper)

count = 0

for i in lower:upper
    global count
    s = string(i)
    if [c for c in s] == sort([c for c in s]) && any(x >= 2 for x in values(counter([c for c in s])))
        count += 1
    end
end

println(count)

count = 0

for i in lower:upper
    global count
    s = string(i)
    if [c for c in s] == sort([c for c in s]) && any(x == 2 for x in values(counter([c for c in s])))
        count += 1
    end
end

println(count)

