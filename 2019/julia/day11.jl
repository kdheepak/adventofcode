using DataStructures

data = read(joinpath(@__DIR__, "../data/day11.txt"), String)

include("vm.jl")

function part1(start_panel_color = 0)

    inp = Channel{Int}(1)
    out = Channel{Int}(1)
    vm = VM(data, input = inp, output = out)

    @async run!(vm)

    current = [0, 0]
    panels = DefaultDict{Tuple{Int, Int}, Int}(0)
    painted = DefaultDict{Tuple{Int, Int}, Int}(0)
    movement = Dict{Symbol, Vector{Int}}(:up => [0, 1], :left => [-1, 0], :down => [0, -1], :right => [1, 0])
    facing = :up
    panels[current...] = start_panel_color
    while vm.halted == false

        put!(inp, panels[current...])

        panels[current...] = take!(out)
        painted[current...] += 1

        direction = take!(out)
        if direction == 0 && facing == :up
            facing = :left
        elseif direction == 1 && facing == :up
            facing = :right
        elseif direction == 0 && facing == :left
            facing = :down
        elseif direction == 1 && facing == :left
            facing = :up
        elseif direction == 0 && facing == :down
            facing = :right
        elseif direction == 1 && facing == :down
            facing = :left
        elseif direction == 0 && facing == :right
            facing = :up
        elseif direction == 1 && facing == :right
            facing = :down
        else
            error("Unknown facing: $facing")
        end

        x, y = movement[facing]
        current[1] += x
        current[2] += y

    end

    return painted, panels

end

painted, panels = part1()
@assert length(painted) == 1771

function part2()
    _, panels = part1(1)
    maxx = maximum(x for (x, y) in keys(panels))
    minx = minimum(x for (x, y) in keys(panels))
    miny = minimum(y for (x, y) in keys(panels))
    maxy = maximum(y for (x, y) in keys(panels))
    io = IOBuffer()
    for y in maxy:-1:miny
        for x in minx:maxx
            print(io, panels[x, y] == 1 ? "█" : " ")
        end
        println(io)
    end
    String(take!(io))
end

@assert split(strip(part2())) == split(strip("""
  █  █  ██  ████ █  █   ██ █  █ █  █ ████
  █  █ █  █ █    █  █    █ █  █ █  █    █
  ████ █    ███  ████    █ ████ █  █   █
  █  █ █ ██ █    █  █    █ █  █ █  █  █
  █  █ █  █ █    █  █ █  █ █  █ █  █ █
  █  █  ███ ████ █  █  ██  █  █  ██  ████
 """))
