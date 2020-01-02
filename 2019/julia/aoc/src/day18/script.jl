readInput() = read(joinpath(@__DIR__, "./input.txt"), String)

part1(data = readInput()) = bfs(data)

generate_tunnels(data) = Matrix{Char}(permutedims(hcat(collect.(String.(split(strip(data), '\n')))...)))

bfs(data::AbstractString) = bfs(generate_tunnels(data))

const DIRECTION = Dict{Int, Tuple{Int, Int}}(
    1 => (0, 1),
    2 => (0, -1),
    3 => (1, 0),
    4 => (-1, 0),
)

function bfs(tunnels)
    r, c = findfirst(==('@'), tunnels).I
    k = Set{Char}()
    d = 0
    Q = [(r, c, k, d)]
    SEEN = Set{String}()
    total_keys = Set{Char}()
    for i in tunnels
        if 'a' <= i <= 'z'
            push!(total_keys, i)
        end
    end
    while length(Q) > 0
        r, c, k, d = popfirst!(Q)
        ks = string(sort(collect(k))...)
        if "$r,$c,$ks" ∈ SEEN
            continue
        else
            push!(SEEN, "$r,$c,$ks")
        end
        if !(1 <= r <= size(tunnels, 1) && 1 <= c <= size(tunnels, 2) && tunnels[r, c] != '#')
            continue
        end
        if 'A' <= tunnels[r, c] <= 'Z' && lowercase(tunnels[r, c]) ∉ k
            continue
        end
        k = Set{Char}(k)
        if 'a' <= tunnels[r, c] <= 'z'
            push!(k, tunnels[r, c])
        end
        if length(k) == length(total_keys)
            break
        end
        for i in 1:4
            dr, dc = DIRECTION[i]
            push!(Q, (r + dr, c + dc, k, d + 1))
        end
    end
    return d
end


function bfs_async(tunnels)
    r, c = findfirst(==('@'), tunnels).I
    k = Set{Char}()
    d = 0
    Q = [(r, c, k, d)]
    SEEN = Set{String}()

    current_quadrant_keys = Set{Char}()
    for i in tunnels
        if 'a' <= i <= 'z'
            push!(current_quadrant_keys, i)
        end
    end

    while length(Q) > 0
        r, c, k, d = popfirst!(Q)
        ks = string(sort(collect(k))...)
        if "$r,$c,$ks" ∈ SEEN
            continue
        else
            push!(SEEN, "$r,$c,$ks")
        end
        if !(1 <= r <= size(tunnels, 1) && 1 <= c <= size(tunnels, 2) && tunnels[r, c] != '#')
            continue
        end
        if 'A' <= tunnels[r, c] <= 'Z' && lowercase(tunnels[r, c]) ∉ k && lowercase(tunnels[r, c]) ∈ current_quadrant_keys
            continue
        end
        k = Set{Char}(k)
        if 'a' <= tunnels[r, c] <= 'z'
            push!(k, tunnels[r, c])
        end
        if length(k) == length(current_quadrant_keys)
            break
        end
        for i in 1:4
            dr, dc = DIRECTION[i]
            push!(Q, (r + dr, c + dc, k, d + 1))
        end
    end
    return d
end

function part2(data = readInput())
    tunnels = generate_tunnels(data)
    r, c = findfirst(==('@'), tunnels).I
    tunnels[r-1:r+1, c-1:c+1] = [
        '@' '#' '@'
        '#' '#' '#'
        '@' '#' '@'
    ]

    t1 = bfs_async(tunnels[1:r, 1:c])
    t2 = bfs_async(tunnels[1:r, c:end])
    t3 = bfs_async(tunnels[r:end, 1:c])
    t4 = bfs_async(tunnels[r:end, c:end])

    return sum([
        t1,
        t2,
        t3,
        t4,
    ])
end

using Test

function runtests()

    @testset "Day 18: Part 1" begin
        tdata = """
        #########
        #b.A.@.a#
        #########
        """
        @test part1(tdata) == 8

        tdata = """
        ########################
        #f.D.E.e.C.b.A.@.a.B.c.#
        ######################.#
        #d.....................#
        ########################
        """
        @test part1(tdata) == 86

        tdata = """
        ########################
        #...............b.C.D.f#
        #.######################
        #.....@.a.B.c.d.A.e.F.g#
        ########################
        """
        @test part1(tdata) == 132

        tdata = """
        #################
        #i.G..c...e..H.p#
        ########.########
        #j.A..b...f..D.o#
        ########@########
        #k.E..a...g..B.n#
        ########.########
        #l.F..d...h..C.m#
        #################
        """
        @test part1(tdata) == 136

        tdata = """
        ########################
        #@..............ac.GI.b#
        ###d#e#f################
        ###A#B#C################
        ###g#h#i################
        ########################
        """
        @test part1(tdata) == 81

        @test part1() == 4900
    end

    @testset "Day 18: Part 2" begin
        tdata = """
        #######
        #a.#Cd#
        ##...##
        ##.@.##
        ##...##
        #cB#Ab#
        #######
        """
        @test part2(tdata) == 8

        tdata = """
        ###############
        #d.ABC.#.....a#
        ######...######
        ######.@.######
        ######...######
        #b.....#.....c#
        ###############
        """
        @test part2(tdata) == 24

        tdata = """
        #############
        #DcBa.#.GhKl#
        #.###...#I###
        #e#d#.@.#j#k#
        ###C#...###J#
        #fEbA.#.FgHi#
        #############
        """
        @test_broken part2(tdata) == 32

        @test part2() == 2462
    end
end

