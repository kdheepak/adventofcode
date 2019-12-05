using OffsetArrays

data = readlines(abspath(joinpath(@__DIR__, "../data/day05.txt")))

INTCODE = [parse(Int, s) for s in split(data[1], ',')]

function f(intcode, input=1)

    intcode = OffsetArray(copy(intcode), -1)
    position = 0
    output = -1

    while intcode[position] != 99

        op = intcode[position] % 100

        if op == 1
            modec = (intcode[position] ÷ 100) % 10
            if modec == 0
                c = intcode[intcode[position + 1]]
            elseif modec == 1
                c = intcode[position + 1]
            else
                error("Unknown intcode[position]: $(intcode[position])")
            end

            modeb = (intcode[position] ÷ 1000) % 10
            if modeb == 0
                b = intcode[intcode[position + 2]]
            elseif modeb == 1
                b = intcode[position + 2]
            else
                error("Unknown intcode[position]: $(intcode[position])")
            end

            if (intcode[position] ÷ 10000) % 10 == 0
                intcode[intcode[position + 3]] = c + b
            elseif (intcode[position] ÷ 10000) % 10 == 1
                error("Output cannot be in immediate mode")
            else
                error("Unknown intcode[position]: $(intcode[position])")
            end

            position = position + 4

        elseif op == 2
            if (intcode[position] ÷ 100) % 10 == 0
                c = intcode[intcode[position+1]]
            elseif (intcode[position] ÷ 100) % 10 == 1
                c = intcode[position + 1]
            else
                error("Unknown intcode[position]: $(intcode[position])")
            end

            if (intcode[position] ÷ 1000) % 10 == 0
                b = intcode[intcode[position + 2]]
            elseif (intcode[position] ÷ 1000) % 10 == 1
                b = intcode[position + 2]
            else
                error("Unknown intcode[position]: $(intcode[position])")
            end

            if (intcode[position] ÷ 10000) % 10 == 0
                intcode[intcode[position + 3]] = c * b
            elseif (intcode[position] ÷ 10000) % 10 == 1
                error("Output cannot be in immediate mode")
            else
                error("Unknown intcode[position]: $(intcode[position])")
            end

            position = position + 4

        elseif op == 3
            if (intcode[position] ÷ 100) % 10 == 0
                b = intcode[position + 1]
                # b = intcode[intcode[position+1]]
            elseif (intcode[position] ÷ 100) % 10 == 1
                # b = intcode[position + 1]
                error("what")
            else
                error("Unknown intcode[position]: $(intcode[position])")
            end

            if (intcode[position] ÷ 1000) % 10 == 0
                intcode[b] = input
            elseif (intcode[position] ÷ 1000) % 10 == 1
                error("Output cannot be in immediate mode")
            else
                error("Unknown intcode[position]: $(intcode[position])")
            end

            position = position + 2
        elseif op == 4
            if (intcode[position] ÷ 100) % 10 == 0
                b = intcode[intcode[position+1]]
            elseif (intcode[position] ÷ 100) % 10 == 1
                b = intcode[position + 1]
            else
                error("Unknown intcode[position]: $(intcode[position])")
            end

            if (intcode[position] ÷ 1000) % 10 == 0
                output = b
                if output != 0 && intcode[position + 2] != 99
                    error("Something went wrong")
                elseif output != 0 && intcode[position + 2] == 99
                    return output
                else
                    @assert output == 0
                end
            elseif (intcode[position] ÷ 1000) % 10 == 1
                error("Output cannot be in immediate mode")
            else
                error("Unknown intcode[position]: $(intcode[position])")
            end

            position = position + 2
        elseif op == 5 # jump-if-true

            modec = (intcode[position] ÷ 100) % 10
            if modec == 0
                c = intcode[intcode[position + 1]]
            elseif modec == 1
                c = intcode[position + 1]
            else
                error("Unknown intcode[position]: $(intcode[position])")
            end

            modeb = (intcode[position] ÷ 1000) % 10
            if modeb == 0
                b = intcode[intcode[position + 2]]
            elseif modeb == 1
                b = intcode[position + 2]
            else
                error("Unknown intcode[position]: $(intcode[position])")
            end

            if c != 0
                position = b
            else
                position += 3
            end
        elseif op == 6 # jump-if-true

            modec = (intcode[position] ÷ 100) % 10
            if modec == 0
                c = intcode[intcode[position + 1]]
            elseif modec == 1
                c = intcode[position + 1]
            else
                error("Unknown intcode[position]: $(intcode[position])")
            end

            modeb = (intcode[position] ÷ 1000) % 10
            if modeb == 0
                b = intcode[intcode[position + 2]]
            elseif modeb == 1
                b = intcode[position + 2]
            else
                error("Unknown intcode[position]: $(intcode[position])")
            end

            if c == 0
                position = b
            else
                position += 3
            end
        elseif op == 7 # less than
            modec = (intcode[position] ÷ 100) % 10
            if modec == 0
                c = intcode[intcode[position + 1]]
            elseif modec == 1
                c = intcode[position + 1]
            else
                error("Unknown intcode[position]: $(intcode[position])")
            end

            modeb = (intcode[position] ÷ 1000) % 10
            if modeb == 0
                b = intcode[intcode[position + 2]]
            elseif modeb == 1
                b = intcode[position + 2]
            else
                error("Unknown intcode[position]: $(intcode[position])")
            end
            if c < b
                intcode[intcode[position + 3]] = 1
            else
                intcode[intcode[position + 3]] = 0
            end
            position += 4
        elseif op == 8 # equal
            modec = (intcode[position] ÷ 100) % 10
            if modec == 0
                c = intcode[intcode[position + 1]]
            elseif modec == 1
                c = intcode[position + 1]
            else
                error("Unknown intcode[position]: $(intcode[position])")
            end

            modeb = (intcode[position] ÷ 1000) % 10
            if modeb == 0
                b = intcode[intcode[position + 2]]
            elseif modeb == 1
                b = intcode[position + 2]
            else
                error("Unknown intcode[position]: $(intcode[position])")
            end
            if c == b
                intcode[intcode[position + 3]] = 1
            else
                intcode[intcode[position + 3]] = 0
            end
            position += 4
        else
            error("position: $(position), intcode[position]: $(intcode[position])")
        end
    end

    return output
end

@show f(INTCODE, 1)

@assert f([3,9,8,9,10,9,4,9,99,-1,8], 7) == 0
@assert f([3,9,8,9,10,9,4,9,99,-1,8], 8) == 1

@assert f([3,9,7,9,10,9,4,9,99,-1,8], 7) == 1
@assert f([3,9,7,9,10,9,4,9,99,-1,8], 9) == 0

@assert f([3,3,1108,-1,8,3,4,3,99], 7) == 0
@assert f([3,3,1108,-1,8,3,4,3,99], 8) == 1

@assert f([3,3,1107,-1,8,3,4,3,99], 7) == 1
@assert f([3,3,1107,-1,8,3,4,3,99], 8) == 0

@show f(INTCODE, 5)
