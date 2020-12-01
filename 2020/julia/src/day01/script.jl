using DataStructures
using Combinatorics

readInput() = read(joinpath(@__DIR__, "./input.txt"), String)

function expense_report(data, n)
    for items in combinations(data, n)
        sum(items) == 2020 && prod(items)
    end
end

function part1(data = readInput())
    expense_report(parse.(Int, split(strip(data))), 2)
end

function part2(data = readInput())
    expense_report(parse.(Int, split(strip(data))), 3)
end
