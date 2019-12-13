readInput() = read(joinpath(@__DIR__, "./input.txt"), String)

using DataStructures
using TERMIOS
using REPL: Terminals

const T = TERMIOS

include("../vm.jl")

function part1(data = readInput())
    vm = VM(data)
    run!(vm)
    outputs = output(vm)
    return length([i for i in 3:3:length(outputs) if outputs[i] == 2])
end

function part2(data = readInput())
    data = [parse(Int, x) for x in split(strip(data), ",")]
    data[1] = 2
    vm = VM(data)
    @async run!(vm)
    game = DefaultDict{Tuple{Int, Int}, Int}(0)
    score = 0
    ball = -1, -1
    paddle = -1, -1
    while !vm.halted
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
        if ball[1] > paddle[1]
            put!(vm.input, 1)
        elseif ball[1] < paddle[1]
            put!(vm.input, -1)
        else
            put!(vm.input, 0)
        end
        wait(vm.output)
        draw(game, score)
    end
    while Base.n_avail(vm.output) > 0
        x = take!(vm.output)
        y = take!(vm.output)
        tile = take!(vm.output)
        if x == -1 && y == 0
            score = tile
        end
        game[(x, y)] = tile
    end
    return score
end

function draw(game, score)
    print("$(Terminals.CSI)H")
    print("$(Terminals.CSI)?25l")
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
                print("_")
            elseif game[(x,y)] == 0
                print(" ")
            else
                print("█")
            end
        end
        println()
    end
end

function read_character()
    String(read(stdin, 1))
end

function play(data = readInput())
    print("$(Terminals.CSI)0;1H")
    print("$(Terminals.CSI)2J")
    new_term = T.termios()
    old_term = T.termios()
    T.tcgetattr(stdin, old_term)
    T.tcgetattr(stdin, new_term)
    data = [parse(Int, x) for x in split(strip(data), ",")]
    data[1] = 2
    vm = VM(data)
    @async run!(vm)
    game = DefaultDict{Tuple{Int, Int}, Int}(0)
    score = 0
    ball = -1, -1
    paddle = -1, -1
    new_term.c_lflag &= ~(T.ICANON | T.ECHO)
    cc = [c for c in new_term.c_cc]
    new_term.c_cc = tuple(cc...)
    T.tcsetattr(stdin, T.TCSANOW, new_term)
    print("$(Terminals.CSI)?12l$(Terminals.CSI)?25l")
    while !vm.halted
        wait(vm.output)
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
        draw(game, score)
        c = String(read(stdin, 1))
        if c == "l"
            put!(vm.input, 1)
        elseif c == "h"
            put!(vm.input, -1)
        elseif c == "q"
            break
        else
            put!(vm.input, 0)
        end
    end
    while Base.n_avail(vm.output) > 0
        x = take!(vm.output)
        y = take!(vm.output)
        tile = take!(vm.output)
        if x == -1 && y == 0
            score = tile
        end
        game[(x, y)] = tile
    end
    T.tcsetattr(stdin, T.TCSANOW, old_term)
    print("$(Terminals.CSI)?12l$(Terminals.CSI)?25l")
    return score
end

const solve = part2

# ### Tests

using Test

function runtests()
    @testset "Day 13: Part 1" begin
        @test part1() == 230
    end

    @testset "Day 13: Part 2" begin
        @test part2() == 11140
    end
end
