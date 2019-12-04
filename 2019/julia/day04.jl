using DataStructures

puzzle_input = "134792-675810"

lower, upper = split(puzzle_input, "-")
lower, upper = parse(Int, lower), parse(Int, upper)

ncount = 0

for i in lower:upper
    global ncount
    s = string(i)
    if [c for c in s] == sort([c for c in s]) && any(x >= 2 for x in values(counter([c for c in s])))
        ncount += 1
    end
end

println(ncount)

ncount = 0

for i in lower:upper
    global ncount
    s = string(i)
    if [c for c in s] == sort([c for c in s]) && any(x == 2 for x in values(counter([c for c in s])))
        ncount += 1
    end
end

println(ncount)

# ------------------------------------------------------
# Michael K. Borregaard

ispass(dif) = any(==(0), dif) && all(>=(0), dif)
ispassword(num) = ispass(diff(reverse(digits(num))))
println(count(ispassword, lower:upper))

ispass(num) = all(>=(0), diff(num)) && any(count(==(x), num)==2 for x in num)
ispassword(num) = ispass(reverse(digits(num)))
println(count(ispassword, lower:upper))
