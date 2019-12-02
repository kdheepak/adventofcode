data = open(joinpath(@__DIR__, "./../data/day01.txt")) do f
    readlines(f)
end

f(m) = round(m / 3, RoundDown) - 2

println(sum(f(parse(Int, mass)) for mass in data if mass != ""))

function g(m)
    t = f(m)
    final_mass = t
    while f(t) > 0
        t = f(t)
        final_mass += t
    end
    return final_mass
end

println(sum(g(parse(Int, mass)) for mass in data if mass != ""))
