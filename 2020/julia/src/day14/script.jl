using Combinatorics
using DataStructures

readInput() = read(joinpath(@__DIR__, "./input.txt"), String)

part1(data = readInput()) = f(split(strip(data), '\n'))

part2(data = readInput()) = g(split(strip(data), '\n'))


function f(data)
    largest = 0
    for instruction in data
        if startswith(instruction, "mem")
            first, second = split(instruction, " = ")
            arr_index = parse(Int, replace(replace(first, "mem[" => ""), "]" => ""))
            largest = max(largest, arr_index)
        end
    end
    largest

    memory = [0b000000000000000000000000000000000000 for _ in 1:largest]

    bitmask = ['X' for _ in 1:34]

    for instruction in data
        if startswith(instruction, "mem")
            first, second = split(instruction, " = ")
            arr_index = parse(Int, replace(replace(first, "mem[" => ""), "]" => ""))
            value = parse(Int, strip(second))
            v = implement1(value, bitmask)
            memory[arr_index] = v
        else
            _, bitmask = split(instruction, " = ")
            bitmask = [c for c in bitmask]
        end
    end

    sum(memory) |> Int
end

function implement1(value, bitmask)
    x = string.(reverse(digits(value, base=2, pad=36)))
    y = bitmask
    result = Char[]
    for (i,j) in zip(x, y)
        if j == 'X'
            push!(result, only(i))
        elseif j == '0'
            push!(result, '0')
        elseif j == '1'
            push!(result, '1')
        else
            error("wat")
        end
    end
    r = parse(Int, join(string.(result)), base = 2)
end


function g(data)
    largest = 0
    for instruction in data
        if startswith(instruction, "mem")
            first, second = split(instruction, " = ")
            arr_index = parse(Int, replace(replace(first, "mem[" => ""), "]" => ""))
            largest = max(largest, arr_index)
        end
    end
    largest

    memory = DefaultDict(0); # [0b000000000000000000000000000000000000 for _ in 1:1e9]

    bitmask = ['X' for _ in 1:34]

    for instruction in data
        if startswith(instruction, "mem")
            first, second = split(instruction, " = ")
            arr_index = parse(Int, replace(replace(first, "mem[" => ""), "]" => ""))
            value = parse(Int, strip(second))
            v = implement2(arr_index, bitmask)
            for e in v
                memory[e] = value
            end
        else
            _, bitmask = split(instruction, " = ")
            bitmask = [c for c in bitmask]
        end
    end

    sum(values(memory)) |> Int
end

function implement2(index, bitmask)
    x = string.(reverse(digits(index, base=2, pad=36)))
    y = bitmask
    result = Char[]
    for (i,j) in zip(x, y)
        if j == 'X'
            push!(result, 'X')
        elseif j == '0'
            push!(result, only(i))
        elseif j == '1'
            push!(result, '1')
        else
            error("wat")
        end
    end

    R = result
    number_of_floats = count(==('X'), result)
    C = Vector{String}[]
    for c in 0:(2^number_of_floats)-1
        push!(C, string.(reverse(digits(c, base=2, pad=number_of_floats))))
    end
    final = Int[]
    for element in C
        r = Char[]
        for (i, c) in enumerate(result)
            if c == 'X'
                push!(r, element[1] == "1" ? '1' : '0')
                popfirst!(element)
            else
                push!(r, c)
            end
        end
        push!(final, parse(Int, join(string.(r)), base = 2))
    end
    final
end
