using Test
using DataStructures

include("../vm.jl")

readInput() = read(joinpath(@__DIR__, "./input.txt"), String)

function get_panels(data, start_panel_color = 0)
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

part1(data = readInput()) = length(get_panels(data))

function get_image(data)
    panels = get_panels(data, 1)
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

part2(data = readInput()) = get_image(data)

function runtests()
    @testset "Day 11: Part 1" begin
        @test part1() == 1771
    end
    @testset "Day 11: Part 2" begin
        @test split(strip(part2())) == split(strip("""
    █  █  ██  ████ █  █   ██ █  █ █  █ ████
    █  █ █  █ █    █  █    █ █  █ █  █    █
    ████ █    ███  ████    █ ████ █  █   █
    █  █ █ ██ █    █  █    █ █  █ █  █  █
    █  █ █  █ █    █  █ █  █ █  █ █  █ █
    █  █  ███ ████ █  █  ██  █  █  ██  ████
    """))
    end
end
