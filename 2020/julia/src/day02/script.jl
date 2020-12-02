readInput() = read(joinpath(@__DIR__, "./input.txt"), String)

function part1(data = readInput())
    c = 0
    for line in split(strip(data), '\n')
        policy, password = split(line, ':')
        rule, letter = split(policy, ' ')
        low, high = split(rule, '-')
        letter = [c for c in letter][1]
        if parse(Int, low) <= length([c for c in password if c == letter]) <= parse(Int, high)
            c += 1
        end
    end
    return c
end

function part2(data = readInput())
    c = 0
    for line in split(strip(data), '\n')
        policy, password = split(line, ':')
        rule, letter = split(policy, ' ')
        low, high = split(rule, '-')
        letter = [c for c in letter][1]
        low = parse(Int, low)
        high = parse(Int, high)
        password = strip(password)
        C = [c for c in password]
        if (C[low] == letter && C[high] != letter) || (C[low] != letter && C[high] == letter)
            c += 1
        end
    end
    return c
end
