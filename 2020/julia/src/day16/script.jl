readInput() = strip(read(joinpath(@__DIR__, "./input.txt"), String))

part1(data = readInput()) = f(strip(data))

part2(data = readInput()) = g(strip(data))

function f(data)
    rules, your_ticket, nearby_tickets = split(data, "\n\n")
    rules = split.([r for (_,r) in split.(split(rules, '\n'), ": ")], " or ")

    rules = map(rules) do rule
        r1,r2 = rule
        r1 = parse.(Int, split(r1, '-'))
        r2 = parse.(Int, split(r2, '-'))
        [Set(collect(r1[1]:r1[2])), Set(collect(r2[1]:r2[2]))]
    end

    nearby_tickets = [parse.(Int, ticket) for ticket in split.(split(nearby_tickets, '\n')[2:end], ',')]

    invalid_fields = Int[]
    for ticket in nearby_tickets
        for ticket_field in ticket
            is_valid = []
            for rule_field in rules
                rule1, rule2 = rule_field
                push!(is_valid, ticket_field ∈ rule1 || ticket_field ∈ rule2)
            end
            if !any(is_valid)
                push!(invalid_fields, ticket_field)
            end
        end
    end
    sum(invalid_fields)

end

function g(data)
    rules, your_ticket, nearby_tickets = split(data, "\n\n")
    rules = split.([r for (_,r) in split.(split(rules, '\n'), ": ")], " or ")

    rules = map(rules) do rule
        r1,r2 = rule
        r1 = parse.(Int, split(r1, '-'))
        r2 = parse.(Int, split(r2, '-'))
        [Set(collect(r1[1]:r1[2])), Set(collect(r2[1]:r2[2]))]
    end

    your_ticket = parse.(Int, split(split(your_ticket, '\n')[2], ','))

    nearby_tickets = [parse.(Int, ticket) for ticket in split.(split(nearby_tickets, '\n')[2:end], ',')]

    invalid_fields = Int[]
    valid_tickets = Vector{Int}[]
    for ticket in nearby_tickets
        is_valid_ticket = true
        for ticket_field in ticket
            is_valid = []
            for rule_field in rules
                rule1, rule2 = rule_field
                push!(is_valid, ticket_field ∈ rule1 || ticket_field ∈ rule2)
            end
            if !any(is_valid)
                is_valid_ticket = false
                push!(invalid_fields, ticket_field)
            end
        end
        is_valid_ticket && (push!(valid_tickets, ticket))
    end

    matrix = ones(Bool, length(rules), length(rules))

    for ticket in valid_tickets
        for (i, field) in enumerate(ticket)
            for (j, rule) in enumerate(rules)
                rule1, rule2 = rule
                !(field ∈ rule1 || field ∈ rule2) && ( matrix[i, j] = 0 )
            end
        end
    end

    final = [0 for _ in 1:length(rules)]
    accounted_for = Set{Int}()
    while length(accounted_for) != length(rules)
        for i in 1:length(rules)
            index = [j for j in 1:length(rules) if matrix[i, j] && j ∉ accounted_for]
            if length(index) == 1
                final[i] = only(index)
                push!(accounted_for, only(index))
            end
        end
    end
    final
    answer = 1
    for interest in 1:6
        for (i, index) in enumerate(final)
            if index == interest
                # @show i, index
                answer *= your_ticket[i]
            end
        end
    end
    answer
end


function find_which_rules(ticket_field, rules)
    A = Int[]
    for (i,rule_field) in enumerate(rules)
        rule1, rule2 = rule_field
        if !(ticket_field ∈ rule1 || ticket_field ∈ rule2)
            push!(A, i)
        end
    end
    return A
end
