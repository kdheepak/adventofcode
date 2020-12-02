# based on solution from https://github.com/Seelengrab/AdventOfCode
readInput() = read(joinpath(@__DIR__, "./input.txt"), String)

function parseInput(data)
    data = split(strip(data), '\n')
    line_content = split.(data, ':')
    return map(line_content) do (policy, password)
        rule, letter = split(policy, ' ')
        low, high = parse.(Int, split(rule, '-'))
        letter = [c for c in letter][1]
        (low, high, letter, strip(password))
    end
end

function part1(data = readInput())
    count(parseInput(data)) do (low, high, letter, password)
        low <= count(==(letter), password) <= high
    end
end

function part2(data = readInput())
    count(parseInput(data)) do (low, high, letter, password)
        (password[low] == letter) ⊻ (password[high] == letter)
    end
end
