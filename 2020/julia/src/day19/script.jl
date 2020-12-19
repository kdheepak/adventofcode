readInput() = strip(read(joinpath(@__DIR__, "./input.txt"), String))

part1(data = readInput()) = f(split(strip(data), "\n\n")...)

part2(data = readInput()) = g(split(strip(data), "\n\n")...)

function f(rules, messages)
    rules = split(rules, '\n')
    rules = split.(rules, ": ")
    rules = map(rules) do (n, subrules)
        subrules = strip(subrules, '\"')
        n => subrules
    end
    rules = Dict(rules...)
    messages = String.(split(messages, '\n'))
    r = replace(regex_builder(rules, "0"), " " => "")
    count(!=(nothing), match.(Regex("^$r\$"), messages))
end

function regex_builder(rules, n)
    subrules = rules[n]
    if length(subrules) == 1 && ( subrules[1] == "a" || subrules[1] == "b" )
        return subrules[1]
    end
    for r in eachmatch(r"(\d+)", subrules)
        subrules = replace(subrules, r[1] => regex_builder(rules, r[1]), count = 1)
    end
    if occursin("|", subrules)
        return "( " * subrules * " )"
    else
        return subrules
    end
end

function g(rules, messages)
    rules = split(rules, '\n')
    rules = split.(rules, ": ")
    rules = map(rules) do (n, subrules)
        subrules = strip(subrules, '\"')
        n => subrules
    end

    rules = Dict(rules...)
    messages = String.(split(messages, '\n'))
    rules["8"] = "(42)+"
    rules["11"] = "42 31 | 42 ( 42 31 | 42 ( 42 31 | 42 ( 42 31 | 42 ( 42 31 ) 31 ) 31 ) 31 ) 31"
    r = replace(regex_builder(rules, "0"), " " => "")
    count(!=(nothing), match.(Regex("^$r\$"), messages))
end
