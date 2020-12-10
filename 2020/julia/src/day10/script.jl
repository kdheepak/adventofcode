readInput() = strip(read(joinpath(@__DIR__, "./input.txt"), String))

part1(data = readInput()) = j(parse.(Int, split(data, '\n')))

part2(data = readInput()) = c(parse.(Int, split(data, '\n')))

function j(data)
    rating = 0
    old_adapter = 0
    diff1 = 0
    diff2 = 0
    diff3 = 0
    picks = Int[]
    data = sort(data)
    for adapter in sort(data)
        if adapter == rating+ 1
            diff1 += 1
        end

        if adapter == rating + 2
            diff2 += 1
        end

        if adapter == rating +3
            diff3 += 1
        end

        if adapter < rating
            continue
        end
        push!(picks, adapter)
        rating = adapter
    end
    diff1 * (diff3+1), picks
end
