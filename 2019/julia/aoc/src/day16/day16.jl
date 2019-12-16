using DataStructures

readInput() = read(joinpath(@__DIR__, "./input.txt"), String)


input_signal(data) = [parse(Int, x) for x in strip(data)]

const base_pattern = [0, 1, 0, -1]

@inline function base_pattern_generator(index, repeat)
    @inbounds base_pattern[rem(index ÷ repeat, length(base_pattern)) + 1]
end

function find_phase(signal)
    output = Int[]
    bp = nothing
    for repeat in 1:length(signal)
        sum = 0
        for (i, d) in enumerate(signal)
            sum += d * base_pattern_generator(i, repeat)
        end
        push!(output, abs(rem(sum, 10)))
    end
    return output
end


function part1(data = readInput())
    output = input_signal(data)
    for p in 1:100
        output = find_phase(output)
    end
    return join(output[1:8])
end

@assert part1("80871224585914546619083218645595") == "24176176"
@assert part1("19617804207202209144916044189917") == "73745418"
@assert part1("69317163492948606335995924319873") == "52432133"
@assert part1() == "85726502"

part2("03036732577212944063491565474664")