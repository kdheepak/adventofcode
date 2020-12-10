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

function c(data)
    _, data = j(data)
    push!(data, data[end] + 3)
    pushfirst!(data, 0)
    memoize = Dict{Int, Int}()
    check(data, 1, memoize)
end

function check(data, i, memoize)
    @show data, data[i], memoize
    if i ∈ keys(memoize)
        println("Already found path $i: $(data[i]) -> $(data[end]): $(memoize)")
        return memoize[i]
    end
    if i == length(data)
        println("Found a valid path: $memoize")
        return 1
    end
    counter = 0
    if i + 3 <= length(data) && data[i + 3] - data[i] <= 3
        @show data[i:i+3]
        counter += check(data, i + 3, memoize)
    end
    if i + 2 <= length(data) && data[i + 2] - data[i] <= 3
        @show data[i:i+2]
        counter += check(data, i + 2, memoize)
    end
    if i + 1 <= length(data) && data[i + 1] - data[i] <= 3
        @show data[i:i+1]
        counter += check(data, i + 1, memoize)
    end
    return memoize[i] = counter
end
