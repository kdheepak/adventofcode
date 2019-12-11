using DataStructures

data = read(joinpath(@__DIR__, "../data/day11.txt"), String)

include("vm.jl")

function get_panels(start_panel_color = 0)
    inp = Channel{Int}(1)
    out = Channel{Int}(1)
    vm = VM(data, input = inp, output = out)
    @async run!(vm)
    current = 0 + 0im
    panels = DefaultDict(0, [(current, 0)])
    facing = 0 + 1im
    panels[current] = start_panel_color
    while !vm.halted
        put!(inp, panels[current])
        panels[current] = take!(out)
        direction = take!(out)
        turn = direction == 0 ? -im : im
        facing *= turn
        current += facing
    end
    return panels
end

panels = get_panels()
@assert length(panels) == 1771

function get_image()
    panels = get_panels(1)
    minx, maxx = extrema(real.(keys(panels)))
    miny, maxy = extrema(imag.(keys(panels)))
    io = IOBuffer()
    for y in maxy:-1:miny
        for x in maxx:-1:minx
            print(io, panels[x + y*im] == 1 ? "█" : " ")
        end
        println(io)
    end
    String(take!(io))
end

@assert split(strip(get_image())) == split(strip("""
  █  █  ██  ████ █  █   ██ █  █ █  █ ████
  █  █ █  █ █    █  █    █ █  █ █  █    █
  ████ █    ███  ████    █ ████ █  █   █
  █  █ █ ██ █    █  █    █ █  █ █  █  █
  █  █ █  █ █    █  █ █  █ █  █ █  █ █
  █  █  ███ ████ █  █  ██  █  █  ██  ████
 """))
