readInput() = read(joinpath(@__DIR__, "./input.txt"), String)

include("../vm.jl")

part2(data = readInput()) = nothing

function build_view(o)
    s = join([Char(x) for x in o])
    return reshape([c for c in replace(s, "\n"=>"")], length(split(s)[1]), :)
end

function get_alignment(view)
    alignment = 0
    x, y = size(view)
    for j in 2:y-1
        for i in 2:x-1
            if view[i, j] == '#' &&
                view[i+1, j] == '#' &&
                view[i, j+1] == '#' &&
                view[i-1, j] == '#' &&
                view[i, j-1] == '#'
                alignment += (i-1)*(j-1)
            end
        end
    end
    return alignment
end

function part1(data = readInput())
    vm = VM(data)
    run!(vm)
    o = output(vm)
    view = build_view(o)
    return get_alignment(view)
end

# ### Tests

using Test                                                      #src

function runtests()                                             #src
    @testset "Day 17: Part 1" begin                             #src
@test get_alignment(build_view("""
..#..........
..#..........
#######...###
#.#...#...#.#
#############
..#...#...#..
..#####...^..
""")) == 76
@test part1() == 3936
    end                                                         #src
end                                                             #src

