using Test

readInput() = read(joinpath(@__DIR__, "./input.txt"), String)

include("../vm.jl")

function part1(data = readInput())
    vm = VM(data, input = channel(Int[1]))
    run!(vm)
    return output(vm)
end

function part2(data = readInput())
    vm = VM(data, input = channel(Int[2]))
    run!(vm)
    return output(vm)
end

function runtests()
    @testset "Day 09: Part 1" begin
        tdata = [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]
        vm = VM(tdata)
        run!(vm)
        @test output(vm) == [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]

        tdata = [1102,34915192,34915192,7,4,7,99,0]
        vm = VM(tdata)
        run!(vm)
        @test length(digits(output(vm)[1])) == 16

        tdata = [104,1125899906842624,99]
        vm = VM(tdata)
        run!(vm)
        @test output(vm) == [1125899906842624]

        @test part1() == [3335138414]
    end
    @testset "Day 09: Part 2" begin
        t = @elapsed begin
            @test part2() == [49122]
        end
        @test t < 0.1
    end
end
