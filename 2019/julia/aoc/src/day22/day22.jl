using OffsetArrays

readInput() = read(joinpath(@__DIR__, "./input.txt"), String)

part1(data = readInput()) = findfirst(==(2019), shuffle(data))-1

part2(data = readInput()) = nothing

function deal_into_new_stack(cards)
    reverse(cards)
end

function deal_with_increment(cards, increment)
    new_cards = zeros(Int, length(cards))
    for (i, c) in enumerate(cards)
        j = ((i-1) * increment) % length(cards)
        new_cards[j + 1] = cards[i]
    end
    return new_cards
end

function cut(cards, n)
    if n < 0
        return vcat(cards[end-abs(n)+1:end], cards[1:end-abs(n)])
    else
        return vcat(cards[n+1:end], cards[1:n])
    end
end

create_deck(s) = collect(0:s)

@assert cut(create_deck(9), 3) == [3, 4, 5, 6, 7, 8, 9, 0, 1, 2]
@assert cut(create_deck(9), -4) == [6, 7, 8, 9, 0, 1, 2, 3, 4, 5]

@assert deal_with_increment(create_deck(9), 3) == [0, 7, 4, 1, 8, 5, 2, 9, 6, 3]

function shuffle(data = readInput(), n=10006)
    cards = create_deck(n)
    for line in split(strip(data), "\n")
        if startswith(line, "cut")
            cards = cut(cards, parse(Int, split(line)[end]))
        elseif startswith(line, "deal with increment")

            cards = deal_with_increment(cards, parse(Int, split(line)[end]))
        else
            cards = deal_into_new_stack(cards)
        end
    end
    return cards
end

@assert shuffle("""
    deal with increment 7
    deal into new stack
    deal into new stack
    """, 9) == [0, 3, 6, 9, 2, 5, 8, 1, 4, 7]

@assert shuffle("""
    cut 6
    deal with increment 7
    deal into new stack
    """, 9) == [3, 0, 7, 4, 1, 8, 5, 2, 9, 6]


@assert shuffle("""
    deal with increment 7
    deal with increment 9
    cut -2
    """, 9) == [6, 3, 0, 7, 4, 1, 8, 5, 2, 9]

@assert shuffle("""
    deal into new stack
    cut -2
    deal with increment 7
    cut 8
    cut -4
    deal with increment 7
    cut 3
    deal with increment 9
    deal with increment 3
    cut -1
    """, 9) == [9, 2, 5, 8, 1, 4, 7, 0, 3, 6]
