readInput() = read(joinpath(@__DIR__, "./input.txt"), String)

using DataStructures

include("../vm.jl")

function part1(data = readInput())
    vm = VM(data)
    run!(vm)
    outputs = output(vm)
    return length([i for i in 3:3:length(outputs) if outputs[i] == 2])
end

function draw(game)
    if length(keys(game)) == 0
        return
    end
    minx, maxx = extrema(x for (x,y) in keys(game))
    miny, maxy = extrema(y for (x,y) in keys(game))
    for y in miny:maxy
        for x in minx:maxx
            if game[(x,y)] == 4
                print("O")
            elseif game[(x,y)] == 3
                print("█")
            elseif game[(x,y)] == 0
                print(" ")
            else
                print("█")
            end
        end
        println()
    end
end

function part2(data = readInput())
    data = [parse(Int, x) for x in split(strip(data), ",")]
    data[1] = 2
    vm = VM(data, input = Channel{Int}())
    @async run!(vm)
    game = DefaultDict{Tuple{Int, Int}, Int}(0)
    score = 0
    ball = -1, -1
    paddle = -1, -1
    while !vm.halted
        if Base.n_avail(vm.output) > 0
            while Base.n_avail(vm.output) > 0
                x = take!(vm.output)
                y = take!(vm.output)
                tile = take!(vm.output)
                if x == -1 && y == 0
                    score = tile
                elseif tile == 4
                    ball = (x, y)
                elseif tile == 3
                    paddle = (x, y)
                else
                end
                game[(x, y)] = tile
            end
        else
            if ball[1] > paddle[1]
                put!(vm.input, 1)
            elseif ball[1] < paddle[1]
                put!(vm.input, -1)
            else
                put!(vm.input, 0)
            end
            # sleep(0.0001)
        end
    end
    while Base.n_avail(vm.output) > 0
        x = take!(vm.output)
        y = take!(vm.output)
        tile = take!(vm.output)
        if x == -1 && y == 0
            score = tile
        elseif tile == 4
            ball = (x, y)
        elseif tile == 3
            paddle = (x, y)
        else
        end
        game[(x, y)] = tile
    end
    return score
end
