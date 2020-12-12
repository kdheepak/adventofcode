readInput() = strip(read(joinpath(@__DIR__, "./input.txt"), String))

part1(data = readInput()) = f(split(data, '\n'))

part2(data = readInput()) = g(split(data, '\n'))

function f(data)
    current = 0 + 0im
    direction = 1 + 0im
    data = map(data) do d
        d[1], parse(Int, d[2:end])
    end
    for (action, move) in data
        if action == 'N'
            current += move * (0 + 1im)
        elseif action == 'S'
            current += move * (0 - 1im)
        elseif action == 'E'
            current += move * (1 + 0im)
        elseif action == 'W'
            current += move * (-1 + 0im)
        elseif action == 'L'
            while move / 90 != 0
                direction *= im
                move -= 90
            end
        elseif action == 'R'
            while move / 90 != 0
                direction *= -im
                move -= 90
            end
        elseif action == 'F'
            current += direction * move
        end
        @show action, move, current
    end
    abs(current.re) + abs(current.im)
end


function g(data)
    waypoint = 10 + 1im
    current = 0 + 0im
    direction = 1 + 0im
    data = map(data) do d
        d[1], parse(Int, d[2:end])
    end
    for (action, move) in data
        if action == 'N'
            waypoint += move * (0 + 1im)
        elseif action == 'S'
            waypoint += move * (0 - 1im)
        elseif action == 'E'
            waypoint += move * (1 + 0im)
        elseif action == 'W'
            waypoint += move * (-1 + 0im)
        elseif action == 'L'
            while move / 90 != 0
                waypoint *= im
                move -= 90
            end
        elseif action == 'R'
            while move / 90 != 0
                waypoint *= -im
                move -= 90
            end
        elseif action == 'F'
            current += waypoint * move
        end
        @show action, move, current
    end
    abs(current.re) + abs(current.im)
end
