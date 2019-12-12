using Test

readInput() = strip(read(joinpath(@__DIR__, "./input.txt"), String))

fuel_requirements(mass) = round(mass / 3, RoundDown) - 2

part1(data = readInput()) = sum(fuel_requirements(parse(Int, mass)) for mass in split(strip(data)))

function total_fuel_requirements(mass)
    fuel = fuel_requirements(mass)
    return fuel > 0 ? fuel + total_fuel_requirements(fuel) : 0
end

part2(data = readInput()) = sum(total_fuel_requirements(parse(Int, mass)) for mass in split(strip(data)))

function runtests()
    @testset "Day 01: Part 1" begin
        @test fuel_requirements(12) == 2
        @test fuel_requirements(14) == 2
        @test fuel_requirements(1969) == 654
        @test fuel_requirements(100756) == 33583
        @test part1() == 3262358
    end
    @testset "Day 01: Part 2" begin
        @test total_fuel_requirements(14) == 2
        @test total_fuel_requirements(1969) == 966
        @test total_fuel_requirements(100756) == 50346

        @test part2() == 4890696
    end
end
