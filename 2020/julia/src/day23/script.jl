using DataStructures
using Crayons

readInput() = strip(read(joinpath(@__DIR__, "./input.txt"), String))

part1(data = readInput()) = f([parse(Int, c) for c in strip(data)])

part2(data = readInput()) = g([parse(Int, c) for c in strip(data)])

function show_cups(cups, current)

    print("cups:")
    for (i, c) in enumerate(cups)
        if c == 1
            c = join([Crayon(bold = true), " $c", Crayon(bold = false)])
        end
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

import Base.show

mutable struct Cup
    label::Int
    next::Union{Cup, Nothing}
end

function Base.show(io::IO, c::Cup)
    print(io, "$(c.label)")
end

function next(c::Cup, n = 1)
    for _ in eachindex(n)
        c = c.next
    end
    return c
end

function g(data)

    cups = [Cup(c, nothing) for c in data]
    current_cup = first(cups)

    all_cups = Dict{Int, Cup}()

    for (i, c) in enumerate(cups)
        if i == 1
            last(cups).next = c
        else
            cups[i-1].next = c
        end
        all_cups[c.label] = c
    end

    minimum_label = min([c.label for c in cups]...)
    maximum_label = max([c.label for c in cups]...)

    MAX_CUPS = 1000000
    last_cup = last(cups)
    for i in (maximum_label+1):MAX_CUPS
        c = Cup(i, nothing)
        all_cups[c.label] = c
        last_cup.next = c
        last_cup = c
    end
    last_cup.next = current_cup

    MAX_MOVE = 10000000
    maximum_label = MAX_CUPS

    move = 0
    while true
        move += 1

        # println()
        # println("--- move $move ---")
        # show_cups2(current_cup, maximum_label)

        last_cup_label = current_cup.label
        label = last_cup_label - 1
        if label < minimum_label
            label = maximum_label
        end

        c1 = next(current_cup)
        c2 = next(c1)
        c3 = next(c2)

        pickup = [c1.label, c2.label, c3.label]

        # println("pick up: $pickup")
        while label ∈ pickup
            label -= 1
            if label < minimum_label
                label = maximum_label
            end
        end

        destination_cup = all_cups[label]

        # println("destination: $label")

        # remove pickup
        current_cup.next = c3.next

        # insert pickup
        c3.next = destination_cup.next
        destination_cup.next = c1

        current_cup = next(current_cup)

        move >= MAX_MOVE && break
    end

    r = Int[]
    current_cup = all_cups[1]
    # show_cups2(current_cup, maximum_label)

    current_cup = next(current_cup)
    push!(r, current_cup.label)
    current_cup = next(current_cup)
    push!(r, current_cup.label)

    prod(r)
end

function show_cups2(current, maximum_label)
    s = Set{Int}()
    print("cups:")
    print(" ($(current))")
    push!(s, current.label)
    current = next(current)
    while length(s) < maximum_label
        print(" $current")
        push!(s, current.label)
        current = next(current)
    end
    println()
end
