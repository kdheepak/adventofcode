using Test

readInput() = read(joinpath(@__DIR__, "./input.txt"), String)

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


function part1(data = readInput())
    orbits, _ = get_orbits(split(strip(data)))
    return sum(count_orbits(orbits, k) for k in keys(orbits))
end

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

part2(data = readInput()) = explore(get_orbits(split(strip(data), "\n"))..., "YOU")[2]

function runtests()
    @testset "Day 06: Part 1" begin
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
        """
        @test part1(tdata) == 42
        @test part1() == 158090
    end
    @testset "Day 06: Part 2" begin
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
        """
        @test part2(tdata) == 4
        @test part2() == 241
    end
end
