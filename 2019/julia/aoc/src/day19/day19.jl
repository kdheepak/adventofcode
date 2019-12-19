readInput() = read(joinpath(@__DIR__, "./input.txt"), String)


part2(data = readInput()) = nothing


include("../vm.jl")

function beam_shape(data)
    shape = Dict{Tuple{Int, Int}, Int}()
    for x in 0:50
        for y in 0:50
            vm = VM(String(strip(data)))
            @async run!(vm)
            push!(vm.input, x)
            push!(vm.input, y)
            if take!(vm.output) == 1
                shape[(x, y)] = 1
            end
        end
    end
    return shape
end

part1(data = readInput()) = count(==(1), values(beam_shape(data)))


function draw_beam_shape(data)
    shape = beam_shape(data)
    minx, maxx = extrema(x for (x,y) in keys(shape))
    miny, maxy = extrema(y for (x,y) in keys(shape))
    for y in miny:maxy
        for x in minx:maxx
            if shape[(x,y)] == 1
                print("█")
            else
                print(" ")
            end
        end
        println()
    end
end

function part2(data = readInput())
    x, y = check_for_santa_ship(data)
    return x * 10000 + y
end

function check_for_santa_ship(data)
    x = 44
    y = 50
    while true
        while !check_if_in_beam(x, y)
            x += 1
        end
        if check_if_in_beam(x + 99, y - 99)
            return x - 1, y - 99 - 1
        end
        while check_if_in_beam(x, y)
            y += 1
        end
    end
end

function check_if_in_beam(x, y)
    vm = VM(String(strip(readInput())))
    @async run!(vm)
    push!(vm.input, x)
    push!(vm.input, y)
    return take!(vm.output) == 1 ? true : false
end
