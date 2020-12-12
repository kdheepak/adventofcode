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
        action == 'N' && ( current += move * im )
        action == 'S' && ( current -= move * im )
        action == 'E' && ( current += move )
        action == 'W' && ( current -= move )
        action == 'F' && ( current += direction * move )
        action == 'L' && ( direction *= im^(move ÷ 90) )
        action == 'R' && ( direction *= (-im)^(move ÷ 90) )
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
        action == 'N' && ( waypoint += move * im )
        action == 'S' && ( waypoint -= move * im )
        action == 'E' && ( waypoint += move )
        action == 'W' && ( waypoint -= move )
        action == 'F' && ( current += waypoint * move )
        action == 'L' && ( waypoint *= im^(move ÷ 90) )
        action == 'R' && ( waypoint *= (-im)^(move ÷ 90) )
    end
    abs(current.re) + abs(current.im)
end
