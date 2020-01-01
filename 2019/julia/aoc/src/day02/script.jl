using Test

include("../vm.jl")

function readInput()
    data = open(joinpath(@__DIR__, "./input.txt")) do f
        readlines(f)
    end
    return data
end

function part1(data = readInput())
    INTCODE = [parse(Int, s) for s in split(data[1], ',')]
    intcode = OffsetVector(copy(INTCODE), -1)
    intcode[1] = 12
    intcode[2] = 2
    vm = VM(intcode, input = channel(Int[1]), maxsize = length(intcode))
    run!(vm)
    return vm.code[0]
end

function part2(data = readInput())
    INTCODE = [parse(Int, s) for s in split(data[1], ',')]
    for noun in 0:99
        for verb in 0:99
            intcode = OffsetVector(copy(INTCODE), -1)
            intcode[1] = noun
            intcode[2] = verb
            vm = VM(intcode, input = channel(Int[1]), maxsize = length(intcode))
            run!(vm)
            if vm.code[0] == 19690720
                return noun * 100 + verb
            end
        end
    end
end

function runtests()
    @testset "Day 02: Part 1" begin
        vm = VM([1,9,10,3,2,3,11,0,99,30,40,50], input = channel(Int[1]))
        run!(vm)
        @test vm.code[0] == 3500

        vm = VM([1,0,0,0,99], input = channel(Int[1]))
        run!(vm)
        @test vm.code[0] == 2

        vm = VM([2,3,0,3,99], input = channel(Int[1]))
        run!(vm)
        @test vm.code[3] == 6

        vm = VM([2,4,4,5,99,0], input = channel(Int[1]), maxsize = length([2,4,4,5,99,0]))
        run!(vm)
        @test vm.code[end] == 9801

        vm = VM([1,1,1,4,99,5,6,0,99], input = channel(Int[1]))
        run!(vm)
        @test vm.code[0] == 30

        @test part1() == 4570637
    end
    @testset "Day 02: Part 2" begin
        @test part2() == 5485
    end
end
