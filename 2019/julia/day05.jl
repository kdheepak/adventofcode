using OffsetArrays

data = readlines(abspath(joinpath(@__DIR__, "../data/day05.txt")))

INTCODE = [parse(Int, s) for s in split(data[1], ',')]

function get_parameter(intcode, pos, idx, modes)
    # modes is a one index vector of the mode for each parameter
    return if modes[idx] == 1 # immediate
        intcode[pos + idx]
    elseif modes[idx] == 0 # position
        intcode[intcode[pos + idx]]
    else
        error("Unknown mode")
    end
end

f(intcode, input) = f(OffsetArray(copy(intcode), -1), input)

function f(intcode::OffsetArray{Int, 1, Vector{Int}}, input=1)
    pos = 0
    output = nothing
    MAXIMUM_NUMBER_OF_PARAMETERS = 3

    while intcode[pos] != 99

        # if intcode == [1001, 1, 1, _]
        # op == 01
        # modes == [1, 0]

        op = intcode[pos] % 100
        modes = digits(intcode[pos] ÷ 100)
        while length(modes) < MAXIMUM_NUMBER_OF_PARAMETERS
            push!(modes, 0)
        end

        if op == 1 # +
            p1 = get_parameter(intcode, pos, 1, modes)
            p2 = get_parameter(intcode, pos, 2, modes)
            @assert modes[3] == 0 "Unknown mode: $(intcode[pos])"
            intcode[intcode[pos + 3]] = p1 + p2
            pos += 4 # goto next instruction
        elseif op == 2 # *
            p1 = get_parameter(intcode, pos, 1, modes)
            p2 = get_parameter(intcode, pos, 2, modes)
            @assert modes[3] == 0 "Unknown mode: $(intcode[pos])"
            intcode[intcode[pos + 3]] = p1 * p2
            pos += 4 # goto next instruction
        elseif op == 3 # input
            intcode[intcode[pos + 1]] = input
            pos += 2 # goto next instruction
        elseif op == 4 # output
            p1 = get_parameter(intcode, pos, 1, modes)
            @assert modes[2] == 0 "Unknown mode: $(intcode[pos])"
            output = p1
            if output != 0 && intcode[pos + 2] != 99
                error("Something went wrong")
            else
                @assert output == 0 || intcode[pos + 2] == 99
            end
            pos += 2 # goto next instruction
        elseif op == 5 # jump-if-true
            p1 = get_parameter(intcode, pos, 1, modes)
            p2 = get_parameter(intcode, pos, 2, modes)
            if p1 != 0 # if jump-if-non-zero
                pos = p2
            else
                pos += 3 # goto next instruction
            end
        elseif op == 6 # jump-if-false
            p1 = get_parameter(intcode, pos, 1, modes)
            p2 = get_parameter(intcode, pos, 2, modes)
            if p1 == 0 # jump-if-zero
                pos = p2
            else
                pos += 3 # goto next instruction
            end
        elseif op == 7 # less than
            p1 = get_parameter(intcode, pos, 1, modes)
            p2 = get_parameter(intcode, pos, 2, modes)
            if p1 < p2
                intcode[intcode[pos + 3]] = 1
            else
                intcode[intcode[pos + 3]] = 0
            end
            pos += 4 # goto next instruction
        elseif op == 8 # equal
            p1 = get_parameter(intcode, pos, 1, modes)
            p2 = get_parameter(intcode, pos, 2, modes)
            if p1 == p2
                intcode[intcode[pos + 3]] = 1
            else
                intcode[intcode[pos + 3]] = 0
            end
            pos += 4 # goto next instruction
        else
            error("Something went wrong. pos: $(pos), intcode[pos]: $(intcode[pos])")
        end

    end
    return output
end

@assert f(INTCODE, 1) == 16225258

@assert f([3,9,8,9,10,9,4,9,99,-1,8], 7) == 0
@assert f([3,9,8,9,10,9,4,9,99,-1,8], 8) == 1

@assert f([3,9,7,9,10,9,4,9,99,-1,8], 7) == 1
@assert f([3,9,7,9,10,9,4,9,99,-1,8], 9) == 0

@assert f([3,3,1108,-1,8,3,4,3,99], 7) == 0
@assert f([3,3,1108,-1,8,3,4,3,99], 8) == 1

@assert f([3,3,1107,-1,8,3,4,3,99], 7) == 1
@assert f([3,3,1107,-1,8,3,4,3,99], 8) == 0

@assert f(INTCODE, 5) == 2808771
