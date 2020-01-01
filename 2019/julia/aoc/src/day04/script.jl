readInput() = "134792-675810"

ispassword1(dif::Vector{Int}) = any(==(0), dif) && all(>=(0), dif)
ispassword1(num) = ispassword1(diff(reverse(digits(num))))

function part1(data = readInput())
    lower, upper = parse.(Int, split(data, "-"))
    return count(ispassword1, lower:upper)
end

ispassword2(num::Vector{Int}) = all(>=(0), diff(num)) && any(count(==(x), num)==2 for x in num)
ispassword2(num) = ispassword2(reverse(digits(num)))

function part2(data = readInput())
    lower, upper = parse.(Int, split(data, "-"))
    return count(ispassword2, lower:upper)
end

using Test

function runtests()
    @testset "Day 04: Part 1" begin
        @test ispassword1(111111) == true
        @test ispassword1(223450) == false
        @test ispassword1(123789) == false
        @test part1() == 1955
    end
    @testset "Day 04: Part 2" begin
        @test ispassword2(112233) == true
        @test ispassword2(123444) == false
        @test ispassword2(111122) == true
        @test part2() == 1319
    end
end
