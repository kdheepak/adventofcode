readInput() = strip(read(joinpath(@__DIR__, "./input.txt"), String))

part1(data = readInput()) = f(strip(data))

part2(data = readInput()) = g(strip(data))

function f(data)
    rules, your_ticket, nearby_tickets = split(data, "\n\n")
    rules = Dict(map(split(rules, '\n')) do rule
        m = match(r"([\w ]+): (\d+)-(\d+) or (\d+)-(\d+)", rule)
        rule, r1start, r1end, r2start, r2end = m[1], m[2], m[3], m[4], m[5]
        r1start, r1end, r2start, r2end = parse.(Int, [r1start, r1end, r2start, r2end])
        rule => (r1start:r1end, r2start:r2end)
    end)

    nearby_tickets = [parse.(Int, ticket) for ticket in split.(split(nearby_tickets, '\n')[2:end], ',')]

    invalid_fields = Int[]
    for ticket in nearby_tickets, field in ticket
        # Doesn't satisfy any rule
        !any([field ∈ rule for rule in Iterators.flatten(values(rules))]) && push!(invalid_fields, field)
    end
    sum(invalid_fields)
end

function g(data)
    rules, your_ticket, nearby_tickets = split(data, "\n\n")
    rules = Dict(map(split(rules, '\n')) do rule
        m = match(r"([\w ]+): (\d+)-(\d+) or (\d+)-(\d+)", rule)
        rule, r1start, r1end, r2start, r2end = m[1], m[2], m[3], m[4], m[5]
        r1start, r1end, r2start, r2end = parse.(Int, [r1start, r1end, r2start, r2end])
        rule => (r1start:r1end, r2start:r2end)
    end)

    your_ticket = parse.(Int, split(split(your_ticket, '\n')[2], ','))

    nearby_tickets = [parse.(Int, ticket) for ticket in split.(split(nearby_tickets, '\n')[2:end], ',')]

    invalid_tickets = Int[]
    for (i, ticket) in enumerate(nearby_tickets), field in ticket
        !any([field ∈ rule for rule in Iterators.flatten(values(rules))]) && push!(invalid_tickets, i)
    end
    valid_tickets = deleteat!(nearby_tickets, invalid_tickets)

    # mark fields to rule mapping as false where at least one of the rules is not valid
    valid = ones(Bool, length(first(valid_tickets)), length(rules))
    for ticket in valid_tickets, (i, field) in enumerate(ticket), (j, rule) in enumerate(rules)
        _, (rule1, rule2) = rule
        !(field ∈ rule1 || field ∈ rule2) && ( valid[i, j] = false )
    end

    final = [0 for _ in 1:length(rules)]
    accounted_for = Set{Int}()
    while length(accounted_for) != length(rules)
        for i in 1:length(first(valid_tickets))
            valid_rules = [j for j in 1:length(rules) if valid[i, j] && j ∉ accounted_for]
            if length(valid_rules) == 1
                final[i] = only(valid_rules)
                push!(accounted_for, only(valid_rules))
            end
        end
    end
    answer = 1
    for (interest, k) in enumerate(keys(rules))
        !startswith(k, "departure") && continue
        for (i, index) in enumerate(final)
            index == interest && ( answer *= your_ticket[i] )
        end
    end
    answer
end
