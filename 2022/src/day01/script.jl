readInput() = read(joinpath(@__DIR__, "./input.txt"), String)

function part1()
    data = readInput()
    totals = Int[]
    for elf in split(strip(data), "\n\n")
        push!(totals, sum(parse.(Int, split(elf))))
    end
    maximum(totals)
end

function part2()
    data = readInput()
    totals = Int[]
    for elf in split(strip(data), "\n\n")
        push!(totals, sum(parse.(Int, split(elf))))
    end
    sum(sort(totals)[end-2:end])
end
