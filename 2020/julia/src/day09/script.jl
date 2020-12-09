readInput() = strip(read(joinpath(@__DIR__, "./input.txt"), String))

part1(data = readInput()) = f(parse.(Int,split(data, '\n')))

function f(numbers)
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

part2(data = readInput()) = g(parse.(Int,split(data, '\n')))

function g(numbers)
    idx, num = f(numbers)
    relevant = @view numbers[1:idx-1]
    for i in eachindex(relevant)
        for j in i:lastindex(relevant)
            window = @view relevant[i:j]
            sum(window) == num && return sum(extrema(window))
        end
    end
end

