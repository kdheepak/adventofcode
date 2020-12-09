readInput() = strip(read(joinpath(@__DIR__, "./input.txt"), String))

part1(data = readInput()) = solution1(parse.(Int,split(data, '\n')))

function solution1(numbers)
    preamble = 25
    for i in (preamble + 1):length(numbers)
        check(numbers[i-preamble:i-1], numbers[i]) && continue
        return i, numbers[i]
    end
end

function check(numbers, n)
    for i in numbers, j in numbers
        i + j == n && return true
    end
    false
end

part2(data = readInput()) = solution2(parse.(Int,split(data, '\n')))

function solution2(numbers)
    idx, num = solution1(numbers)
    for i in eachindex(numbers), j in i:lastindex(numbers)
        sum(numbers[i:j]) == num && return sum(extrema(numbers[i:j]))
    end
end

