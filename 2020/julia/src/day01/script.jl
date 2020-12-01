using DataStructures
using Combinatorics

readInput() = read(joinpath(@__DIR__, "./input.txt"), String)

function expense_report(data, n)
    for items in combinations(data, n)
        if sum(items) == 2020
            return prod(items)
        end
    end
end

function part1(data = readInput())
    expense_report(parse.(Int, split(strip(data))), 2)
end

@show part1()

function part2(data = readInput())
    expense_report(parse.(Int, split(strip(data))), 3)
end

@show part2()
