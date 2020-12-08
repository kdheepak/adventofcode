readInput() = strip(read(joinpath(@__DIR__, "./input.txt"), String))

part1(data = readInput()) = boot(split(data, '\n'))

part2(data = readInput()) = corrupt(split(data, '\n'))


function boot(instructions)
    acc = 0
    i = 1
    s = Set()
    while true
        if i ∈ s
            break
        else
            push!(s, i)
        end
        inst, n = split(instructions[i])
        n = parse(Int, n)
        if inst == "acc"
            i += 1
            acc += n
        elseif inst == "jmp"
            i += n
        elseif inst == "nop"
            i += 1
        end
    end
    acc
end

function corrupt(original_instructions)

    for j in 1:length(original_instructions)
        boot_loop_detected = false
        acc = 0
        i = 1
        s = Set()
        instructions = copy(original_instructions)
        if occursin("jmp", instructions[j])
            instructions[j] = replace(instructions[j], "jmp" => "nop")
        elseif occursin("nop", instructions[j])
            instructions[j] = replace(instructions[j], "nop" => "jmp")
        end
        while true
            if i ∈ s
                boot_loop_detected = true
                break
            else
                push!(s, i)
            end
            if i > length(instructions)
                break
            end
            inst, n = split(instructions[i])
            n = parse(Int, n)
            if inst == "acc"
                i += 1
                acc += n
            elseif inst == "jmp"
                i += n
            elseif inst == "nop"
                i += 1
            end
        end
        if !boot_loop_detected
            return acc
        end
    end
    println("didn't find")
end
