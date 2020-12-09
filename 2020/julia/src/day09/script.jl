readInput() = strip(read(joinpath(@__DIR__, "./input.txt"), String))

part1(data = readInput()) = f(parse.(Int,split(data, '\n')))

part2(data = readInput()) = g(parse.(Int,split(data, '\n')))


function f(numbers)
    preamble = 25
    for i in (preamble + 1):length(numbers)
        if check(numbers[i-preamble:i-1], numbers[i])
            continue
        else
            return numbers[i]
            break
        end
    end
end

function check(numbers, n)
    for i in numbers
        for j in numbers
            if i + j == n
                return true
            end
        end
    end
    return false
end

function g(numbers)
    invalid_number = f(numbers)

    start_index = 1
    end_index = 1

    while true
        end_index += 1
        if sum(numbers[start_index:end_index]) == invalid_number
            a = sort(numbers[start_index:end_index])
            return a[begin] + a[end]
        elseif sum(numbers[start_index:end_index]) > invalid_number + 1000
            start_index += 1
            end_index = start_index
        end
    end

end

