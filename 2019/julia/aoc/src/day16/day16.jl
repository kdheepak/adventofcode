using DataStructures

readInput() = read(joinpath(@__DIR__, "./input.txt"), String)


input_signal(data) = [parse(Int, x) for x in strip(data)]

const BASE_PATTERN = [0, 1, 0, -1]

@inline function base_pattern_generator(index, repeat)
    @inbounds BASE_PATTERN[rem(index ÷ repeat, length(BASE_PATTERN)) + 1]
end

function find_phase(signal)
    input = copy(signal)
    for repeat in 1:length(input)
        sum = 0
        for (i, d) in enumerate(input)
            sum += d * base_pattern_generator(i, repeat)
        end
        signal[repeat] = abs(rem(sum, 10))
    end
end

function part1(data = readInput())
    signal = input_signal(data)
    for p in 1:100
        find_phase(signal)
    end
    return join(signal[1:8])
end

@assert part1("80871224585914546619083218645595") == "24176176"
@assert part1("19617804207202209144916044189917") == "73745418"
@assert part1("69317163492948606335995924319873") == "52432133"
@assert part1() == "85726502"

function find_partial_phase(signal)
    input = copy(signal)
    for (i, d) in enumerate(cumsum(reverse(input[(length(input) ÷ 2):end])))
        signal[end-i+1] = d % 10
    end
end

function part2(data = readInput())
    signal = input_signal(repeat(data, 10000))
    offset = parse(Int, join(signal[1:7]))
    for p in 1:100
        find_partial_phase(signal)
    end
    return join(signal[offset+1:offset+8])
end

@assert part2("03036732577212944063491565474664") == "84462026"
@assert part2("02935109699940807407585447034323") == "78725270"
@assert part2("03081770884921959731165446850517") == "53553731"
@assert part2() == "92768399"
