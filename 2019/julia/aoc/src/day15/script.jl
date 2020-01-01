readInput() = read(joinpath(@__DIR__, "./input.txt"), String)

include("../vm.jl")

const NORTH = 1
const SOUTH = 2
const WEST = 3
const EAST = 4
const UNEXPLORED = -1
const WALL = 0
const PATH = 1
const OXYGEN = 2

using DataStructures

DIRECTION = Dict(
    (0 + 1im) => NORTH,
    (0 + -1im) => SOUTH,
    (1 + 0im) => EAST,
    (-1 + 0) => WEST
)

ARROWS = Dict(
    (0 + 1im) => "↑",
    (0 + -1im) => "↓",
    (1 + 0im) => "→",
    (-1 + 0) => "←",
)

function part1(data = readInput())
    map = create_map(DefaultDict(UNEXPLORED))
    map = merge!(map, create_map(DefaultDict(UNEXPLORED), -im))
    path = bfs(copy(map))
    # draw(map, path)
    return length(path)-1
end

function create_map(MAP, sweep=im)
    d = 0 + 0im
    default = 0 + 1im
    pos = 0 + 0im
    data = readInput()
    vm = VM(data)
    @async run!(vm)
    while true
        if MAP[pos + (default * sweep)] == UNEXPLORED || MAP[pos + (default * sweep)] == PATH
            d = (default * sweep)
        elseif MAP[pos + default] == UNEXPLORED || MAP[pos + default] == PATH
            d = default
        elseif MAP[pos + (default * -sweep)] == UNEXPLORED || MAP[pos + (default * -sweep)] == PATH
            d = (default * -sweep)
        elseif MAP[pos - default] == UNEXPLORED || MAP[pos - default] == PATH
            d = -default
        else
            error("Wat")
        end
        push!(vm.input, DIRECTION[d])
        yield()
        status = take!(vm.output)
        if status == WALL
            MAP[pos + d] = WALL
        elseif status == 1
            MAP[pos + d] = PATH
            pos += d
            default = d
        elseif status == OXYGEN
            MAP[pos + d] = OXYGEN
            break
        else
            error("Unknown status: $status")
        end
    end
    return MAP
end

function draw(map, path = ComplexF64[])
    minx, maxx = extrema(real(z) for z in keys(map))
    miny, maxy = extrema(imag(z) for z in keys(map))
    for y in miny:maxy
        for x in minx:maxx
            if x + im*y == 0 + 0im
                print("O")
            elseif map[x + im*y] == 0
                print("█")
            elseif map[x + im*y] == 2
                print("X")
            elseif (x + im*y) ∈ path
                print("x")
            elseif map[x + im*y] == 1
                print(" ")
            else
                print(" ")
            end
        end
        println()
    end
end

function bfs(map, start=(0+0im))
    map = copy(map)
    queue = Deque{Any}()
    push!(queue, [start])
    seen = Set(start)
    while !isempty(queue)
        path = popfirst!(queue)
        z = path[end]
        if map[z] == 2
            return path
        end
        for z2 in [z+1, z+im, z-1, z-im]
            if map[z2] != 0 && z2 ∉ seen
                push!(queue, vcat(path, [z2]))
                push!(seen, z2)
            end
        end
    end
end

function part2(data = readInput())
    map = create_map(DefaultDict(UNEXPLORED))
    map = merge!(map, create_map(DefaultDict(UNEXPLORED), -im))
    minx, maxx = extrema(real(z) for z in keys(map))
    miny, maxy = extrema(imag(z) for z in keys(map))
    longest = 0
    for y in miny:maxy
        for x in minx:maxx
            if map[x+im*y] == 1
                longest = max(longest, length(bfs(copy(map), x+im*y))-1)
            end
        end
    end
    return longest
end

using Test

function runtests()

    @testset "Day 15: Part 1" begin
        @test part1() == 228
    end

    @testset "Day 15: Part 2" begin
        @test part2() == 348
    end

end
