data = open(joinpath(@__DIR__, "./../data/day02.txt")) do f
    readlines(f)
end

INTCODE = [parse(Int, s) for s in split(data[1], ',')]

function f(intcode, a, b)

    intcode = copy(intcode)
    position = 0 + 1
    intcode[1 + 1] = a
    intcode[2 + 1] = b

    while intcode[position] != 99

        if intcode[position] == 1
            p1 = intcode[position+1]
            p2 = intcode[position+2]
            p3 = intcode[position+3]
            intcode[p3+1] = intcode[p1+1] + intcode[p2+1]
        end

        if intcode[position] == 2
            p1 = intcode[position+1]
            p2 = intcode[position+2]
            p3 = intcode[position+3]
            intcode[p3+1] = intcode[p1+1] * intcode[p2+1]
        end

        position = position + 4
    end

    return intcode[1]
end
