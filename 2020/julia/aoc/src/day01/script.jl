
readInput() = read(joinpath(@__DIR__, "./input.txt"), String)

function expense_report(data)
    for (i,item1) in enumerate(data)
        for (j,item2) in enumerate(data)
            for (k,item3) in enumerate(data)
                if item1 + item2 + item3 == 2020 && i != j != k
                    return item1, item2, item3
                end
            end
        end
    end
end

function part1(data = readInput()) 
    i1, i2 = expense_report(parse.(Int, split(strip(data))))
    i1 * i2
end

@show part1()

function part2(data = readInput()) 
    i1, i2, i3 = expense_report(parse.(Int, split(strip(data))))
    i1 * i2 * i3
end

@show part2()
