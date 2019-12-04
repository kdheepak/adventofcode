using OffsetArrays

data = open(joinpath(@__DIR__, "./../data/day02.txt")) do f
    readlines(f)
end

INTCODE = [parse(Int, s) for s in split(data[1], ',')]

function f(intcode, a, b)

    intcode = OffsetArray(copy(intcode), -1)
    position = 0
    intcode[1] = a
    intcode[2] = b

    while intcode[position] != 99

        op = if intcode[position] == 1
            +
        elseif intcode[position] == 2
            *
        else
            error("position: $(position), intcode[position]: $(intcode[position])")
        end

        p1 = intcode[position+1]
        p2 = intcode[position+2]
        p3 = intcode[position+3]

        intcode[p3] = op(intcode[p1], intcode[p2])

        position = position + 4
    end

    return intcode[0]
end

println(f(INTCODE, 12, 2))

for noun in 0:99
    for verb in 0:99
        if f(INTCODE, noun, verb) == 19690720
            println(noun * 100 + verb)
            break
        end
    end
end

#---------------------------------------------------------------
# Tom Kwong

function run!(code, i = 0)
    op = code[i]
    op == 99 && return code[0]
    execute!(Val(op), code, code[i+1:i+3]...)
    run!(code, i+4)
end

execute!(::Val{1}, code, p1, p2, p3) = code[p3] = code[p1] + code[p2]

execute!(::Val{2}, code, p1, p2, p3) = code[p3] = code[p1] * code[p2]

intcode = OffsetArray(INTCODE, -1)
intcode[1] = 12
intcode[2] = 2

run!(intcode)

nothing
