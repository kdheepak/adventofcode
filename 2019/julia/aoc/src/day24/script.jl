readInput() = read(joinpath(@__DIR__, "./input.txt"), String)

part1(data = readInput()) = calculate_biodiversity_rating(find_cycle(strip(data)))

part2(data = readInput()) = nothing

function parse_area(data = readInput())
    data = strip(data)
    area = Array(reshape([c == '#' ? 1 : 0 for c in data if c != '\n'], length(split(data, "\n")), :)')
end

function simulate_life!(area)
    X, Y = size(area)
    status = Dict{Tuple{Int, Int}, Int}()
    for y in 1:Y
        for x in 1:X
            s = 0
            try
                s += area[x - 1, y]
            catch end
            try
                s += area[x, y - 1]
            catch end
            try
                s += area[x, y + 1]
            catch end
            try
                s += area[x + 1, y]
            catch end
            if area[x, y] == 1 && s != 1
                status[(x, y)] = -1
            elseif area[x, y] == 0 && (s == 1 || s == 2)
                status[(x, y)] = 1
            else
                status[(x, y)] = 0
            end
        end
    end
    for (x,y) in keys(status)
        area[x, y] += status[(x, y)]
    end
end

function find_cycle(data = readInput())

    area = parse_area(data)

    hashes = Dict{UInt64, Matrix{Int}}()
    h = hash(area)
    while h ∉ keys(hashes)
        hashes[h] = copy(area)
        simulate_life!(area)
        h = hash(area)
    end

    return hashes[h]
end

function calculate_biodiversity_rating(area)
    X, Y = size(area)
    exponent = 1
    s = 0
    for x in 1:X
        for y in 1:Y
            s += (2 ^ exponent) ÷ 2 * area[x, y]
            exponent += 1
        end
    end
    return s
end


using Test

function runtests()

    test_data = """
    ....#
    #..#.
    #..##
    ..#..
    #....
    """

    @testset "Day 24: Part 1" begin

        @test part1(test_data) == 2129920
        @test part1() == 7543003

    end

    @testset "Day 24: Part 2" begin

    end
end

