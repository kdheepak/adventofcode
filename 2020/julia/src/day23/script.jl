using DataStructures

readInput() = strip(read(joinpath(@__DIR__, "./input.txt"), String))

part1(data = readInput()) = f([parse(Int, c) for c in strip(data)])

part2(data = readInput()) = g([parse(Int, c) for c in strip(data)])

function show_cups(cups, current)

    print("cups:")
    for (i, c) in enumerate(cups)
        if i == current
            print(" ($c)")
        else
            print(" $c")
        end
    end
    println()
end


function f(data)
    current_cup = 1
    move = 0

    cups = data

    while true
        move += 1
        # println()
        # println("--- move $move ---")
        # show_cups(cups, current_cup)
        last_cup_label = cups[current_cup]
        label = cups[current_cup] - 1
        if label < min(cups...)
            label = max(cups...)
        end

        pickup = Int[]
        for i in 1:3
            push!(pickup, cups[mod(current_cup + i - 1, length(cups)) + 1])
        end
        # println("pick up: $pickup")
        new_cups = Int[]
        for c in cups
            if c ∉ pickup
                push!(new_cups, c)
            end
        end
        while label ∈ pickup
            label -= 1
            if label < min(pickup...) && label < min(new_cups...)
                label = max(max(pickup...), max(new_cups...))
            end
        end
        # @show label
        destination_cup = findfirst(x -> x == label, new_cups)
        # println("destination: $label")
        final_cups = Int[]
        for (i, c) in enumerate(new_cups)
            push!(final_cups, c)
            if i == destination_cup
                for dc in pickup
                    push!(final_cups, dc)
                end
            end
        end
        cups = final_cups
        current_cup = findfirst(x -> x == last_cup_label, cups) + 1
        if current_cup > length(cups)
            current_cup = 1
        end
        if move >= 100
            break
        end
    end
    return cups
end

function g(data)
    current_cup = 1
    move = 0

    cups = vcat([data; max(data...):1000000])

    while true
        move += 1
        # println()
        # println("--- move $move ---")
        # show_cups(cups, current_cup)
        last_cup_label = cups[current_cup]
        label = cups[current_cup] - 1
        if label < min(cups...)
            label = max(cups...)
        end

        pickup = Int[]
        for i in 1:3
            push!(pickup, cups[mod(current_cup + i - 1, length(cups)) + 1])
        end
        # println("pick up: $pickup")
        new_cups = Int[]
        for c in cups
            if c ∉ pickup
                push!(new_cups, c)
            end
        end
        while label ∈ pickup
            label -= 1
            if label < min(pickup...) && label < min(new_cups...)
                label = max(max(pickup...), max(new_cups...))
            end
        end
        # @show label
        destination_cup = findfirst(x -> x == label, new_cups)
        # println("destination: $label")
        final_cups = Int[]
        for (i, c) in enumerate(new_cups)
            push!(final_cups, c)
            if i == destination_cup
                for dc in pickup
                    push!(final_cups, dc)
                end
            end
        end
        cups = final_cups
        current_cup = findfirst(x -> x == last_cup_label, cups) + 1
        if current_cup > length(cups)
            current_cup = 1
        end
        mod(move, 1000) == 0 && println("--- Move $move ---")
        if move >= 10000000
            break
        end
    end
    x, y = cups[findfirst(==(1), cups) + 1:findfirst(==(1), cups) + 2]
    return x * y
end
