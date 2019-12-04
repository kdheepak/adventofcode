println(@__DIR__)
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


#--------------------------------------------------------------

p = parse.(Int, readlines(joinpath(@__DIR__, "./../data/day01.txt")))
f(x) = (x ÷ 3) - 2
println(sum(f.(p)))

function g(rem)
    ret = f(rem)
    ret <= 0 ? 0 : ret += g(ret)
end
println(sum(g, p))
