using DataStructures

readInput() = strip(read(joinpath(@__DIR__, "./input.txt"), String))

part1(data = readInput()) = f(parse.(Int, split(data, ',')))

part2(data = readInput()) = g(parse.(Int, split(data, ',')))

function f(data)
    i = 1
    turn = DefaultDict(0)
    for (i,v) in enumerate(data)
        turn[i] = data[i]
    end
    i = length(data) + 1
    last_spoken = nothing
    while true
        if !(last_spoken ∈ values(turn))
            turn[i] = 0
            last_spoken = 0
        else
            # @show last_spoken, values(turn)
            turn_keys = sort([k for (k,v) in zip(keys(turn), values(turn)) if v == last_spoken])
            if length(turn_keys) == 1
                index = turn_keys[1]
            else
                index = turn_keys[end - 1]
            end
            turn[i] = i - 1 - index
            last_spoken = i - 1 - index
        end
        i += 1
        if i > 2020
            @show last_spoken
            break
        end
    end
end

function g(data)
    spoken = Dict{Int, Int}()
    for (i, v) in enumerate(data[1:end-1])
        spoken[v] = i
    end
    i = length(spoken) + 1
    last_spoken = data[end]
    while true
        if last_spoken ∈ keys(spoken)
            last_spoken_turn = spoken[last_spoken]
            spoken[last_spoken] = i
            last_spoken = i - last_spoken_turn
        else
            spoken[last_spoken] = i
            last_spoken = 0
        end
        i += 1
        if i >= 30000000
            @show last_spoken
            break
        end
    end

end
