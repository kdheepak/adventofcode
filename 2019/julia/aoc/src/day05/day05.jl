using Test

include("../vm.jl")

readInput() = read(joinpath(@__DIR__, "./input.txt"), String)

part1(data = readInput()) = output(run!(VM(copy([parse(Int, s) for s in split(strip(data), ',')]), input = channel([1]))))[end]
part2(data = readInput()) = output(run!(VM(copy([parse(Int, s) for s in split(strip(data), ',')]), input = channel([5]), maxsize = length([parse(Int, s) for s in split(strip(data), ',')]))))[end]


function runtests()
    @testset "Day 05: Part 1" begin
        @test part1() == 16225258
    end
    @testset "Day 05: Part 2" begin
        tdata = [3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8]
        @test output(run!(VM(tdata, input = channel([7]), maxsize = length(tdata))))[end] == 0
        @test output(run!(VM(tdata, input = channel([8]), maxsize = length(tdata))))[end] == 1

        tdata = [3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8]
        @test output(run!(VM(tdata, input = channel([7]), maxsize = length(tdata))))[end] == 1
        @test output(run!(VM(tdata, input = channel([9]), maxsize = length(tdata))))[end] == 0

        tdata = [3, 3, 1108, -1, 8, 3, 4, 3, 99]
        @test output(run!(VM(tdata, input = channel([7]), maxsize = length(tdata))))[end] == 0
        @test output(run!(VM(tdata, input = channel([8]), maxsize = length(tdata))))[end] == 1

        tdata = [3, 3, 1107, -1, 8, 3, 4, 3, 99]
        @test output(run!(VM(tdata, input = channel([7]), maxsize = length(tdata))))[end] == 1
        @test output(run!(VM(tdata, input = channel([8]), maxsize = length(tdata))))[end] == 0

        @test part2() == 2808771
    end
end
