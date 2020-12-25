readInput() = strip(read(joinpath(@__DIR__, "./input.txt"), String))

part1(data = readInput()) = f(parse.(BigInt, split(strip(data), '\n'))...)

part2(data = readInput()) = nothing

function f(card_public_key, door_public_key)

    value = 1
    subject_number = 7
    card_loop_size = 0

    while true
        value *= subject_number
        value = value % 20201227
        card_loop_size += 1
        value == card_public_key && break
    end

    transformation(door_public_key, card_loop_size)
end

transformation(subject_number, loop_size) = subject_number ^ loop_size % 20201227
