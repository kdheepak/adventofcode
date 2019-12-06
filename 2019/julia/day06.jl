data = readlines(abspath(joinpath(@__DIR__, "../data/day06.txt")))

function get_orbits(data)
    inorbit = String[]
    aroundorbit = String[]

    for (i, a) in split.(data, ')')
        push!(inorbit, i)
        push!(aroundorbit, a)
    end

    orbits = Dict{String, Vector{String}}()

    for (i, io) in enumerate(inorbit)
        orbits[io] = String[]
    end
    for (i, ao) in enumerate(aroundorbit)
        orbits[ao] = String[]
    end

    for (i, io) in enumerate(inorbit)
        push!(orbits[io], aroundorbit[i])
    end

    mapping = Dict{String, String}()

    for (io, ao) in zip(inorbit, aroundorbit)
        mapping[ao] = io
    end

    return orbits, mapping
end

const Planet = String

function count_orbits(orbits::Dict{Planet, Vector{Planet}}, from_node)
    if orbits[from_node] == []
        return 0
    else
        return length(orbits[from_node]) + sum(count_orbits(orbits, fn) for fn in orbits[from_node])
    end
end

tdata = """
COM)B
B)C
C)D
D)E
E)F
B)G
G)H
D)I
E)J
J)K
K)L
""" |> strip |> split

orbits, _ = get_orbits(tdata)
c = sum(count_orbits(orbits, k) for k in keys(orbits))
@assert c == 42

orbits, _ = get_orbits(data)
c = sum(count_orbits(orbits, k) for k in keys(orbits))
@assert c == 158090
println(c)

######################################################################

function explore(orbits::Dict{Planet, Vector{Planet}}, mapping::Dict{Planet, Planet}, planet::Planet, visited = Planet[], hop=0)
    # println("""exploring $planet after visiting: $(join(visited, ", "))""")
    push!(visited, planet)
    if "SAN" in orbits[planet]
        return true, hop
    end
    for p in orbits[planet]
        if p ∉ visited
            if "SAN" in orbits[p]
                return true, hop
            else
                r, c = explore(orbits, mapping, p, visited, hop+1)
                if r == true
                    return r, c
                end
            end
        end
    end
    if planet in keys(mapping) && mapping[planet] ∉ visited
        r, c = explore(orbits, mapping, mapping[planet], visited, hop+1)
        if r == true
            return r, c
        end
    end
    return false, hop
end

tdata = """
COM)B
B)C
C)D
D)E
E)F
B)G
G)H
D)I
E)J
J)K
K)L
K)YOU
I)SAN
""" |> strip |> split

_, transfers = explore(get_orbits(tdata)..., "YOU")
@assert transfers == 4

orbits, reverse_mapping = get_orbits(data)
_, transfers = explore(orbits, reverse_mapping, "YOU")
@assert transfers == 241
println(transfers)

###########################################################3

using SparseArrays
using LightGraphs

input = hcat((split(line, ")") for line in data)...)
bodys = sort(unique(hcat(input...)))

orbits = SimpleDiGraph(sparse(
    findfirst.(.==(input[1,:]), [bodys]),
    findfirst.(.==(input[2,:]), [bodys]),
    repeat([1], size(input)[2])))

# part 1
com = findfirst(==("COM"), bodys)
println(sum(length.(a_star.([orbits], [com], vertices(orbits)))))

# part 2
you_orbiting = input[1, findfirst(==("YOU"), input[2,:])]
san_orbiting = input[1, findfirst(==("SAN"), input[2,:])]
println(length(a_star(
    SimpleGraph(orbits),
    findfirst(==(you_orbiting), bodys),
    findfirst(==(san_orbiting), bodys))))

