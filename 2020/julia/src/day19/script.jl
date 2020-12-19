readInput() = strip(read(joinpath(@__DIR__, "./input.txt"), String))

part1(data = readInput()) = f(split(strip(data), "\n\n")...)

part2(data = readInput()) = nothing


function f(rules, messages)
    rules = split(rules, '\n')
    rules = split.(rules, ": ")
    rules = map(rules) do (n, rule)
        subrules = String.(split(rule, '|'))
        if length(subrules) == 1 && startswith(subrules[1], '"') && endswith(subrules[1], '"')
            subrules[1] = String(replace(subrules[1], '"' => ""))
        else
            subrules = map(subrules) do subrule
                subrule = parse.(Int, split(subrule, " ", keepempty = false))
                subrule
            end
        end
        parse(Int, n), subrules
    end

    rules = sort(rules, by = x -> x[1])

    messages = String.(split(messages, '\n'))

    memo = Dict()
    count(map(messages) do m
        r, i = matcher!(m, 1, rules[1], rules, memo)
        @show m[i:end]
        r
    end)
end


function matcher!(s, index, rule, rules, memo)
    if (s, index, rule) ∈ keys(memo)
        return memo[(s, index, rule)]
    end
    n, subrules = rule
    if length(subrules) == 1 && subrules[1] isa String
        c = first(s[index:end])
        memo[(s, index, rule)] = (string(c) == subrules[1], index)
        return string(c) == subrules[1], index
    end
    m = Bool[]
    for subrule in subrules
        matches = Bool[]
        tindex = index
        for (i, r) in enumerate(subrule)
            result, tindex = matcher!(s, tindex + i - 1, rules[r + 1], rules, memo)
            push!(matches, result)
        end
        @show matches
        push!(m, all(matches))
    end
    @show index, s[index:end], m
    memo[(s, index, rule)] = (any(m), index + length(subrules[1]))
    return any(m), index + length(subrules[1])
end
