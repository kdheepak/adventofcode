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

function count_orbits(orbits, from_node)
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

c = sum(count_orbits(get_orbits(tdata)[1], k) for k in keys(get_orbits(tdata)[1]))
@assert c == 42

orbits, mapping = get_orbits(data)
c = sum(count_orbits(orbits, k) for k in keys(orbits))
@assert c == 158090
println(c)

######################################################################

function explore(orbits, mapping, planet, visited = String[], hop=0)
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

_, transfers = explore(get_orbits(data)..., "YOU")
@assert transfers == 241
println(transfers)






















