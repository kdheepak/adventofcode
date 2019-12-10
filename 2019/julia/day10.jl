data = read(joinpath(@__DIR__, "./../data/day10.txt"), String)

function count_asteroids(data, x, y)
    data[x, y] != 1 && return 0
    line_of_sight = get_line_of_sight(data, x, y)
    return length(line_of_sight)
end

function distance(a1, a2)
    x1, y1 = a1
    x2, y2 = a2
    return √((x1 - x2)^2 + (y1-y2)^2)
end

function get_line_of_sight(data, x, y)
    line_of_sight = Dict{ComplexF64, Tuple{Int, Int}}()
    rows, cols = size(data)
    for j in 1:cols
        for i in 1:rows
            if x == i && y == j
                continue
            elseif data[i, j] == 1
                z = (x - i) + (y - j)*im
                z = round(z / abs(z), digits=4)
                if z ∉ keys(line_of_sight) || distance((i,j), (x, y)) < distance(line_of_sight[z], (x, y))
                    line_of_sight[z] = (i, j)
                end
            end
        end
    end
    return line_of_sight
end

function g(data::AbstractString)
    data = reshape([
        x == '#' ? 1 : 0
        for x in data if x != '\n'
        ],
        length(split(data)),
        length(split(data)[1]),
    )'
    return data
end


function f(data)
    data = g(data)
    max_asteroids = 0
    px = py = 0
    for x in 1:size(data)[1], y in 1:size(data)[2]
        c = count_asteroids(data, x, y)
        if c > max_asteroids
            max_asteroids = c
            px, py = x, y
        end
    end
    return max_asteroids, (py-1, px-1)
end

tdata = """
.#..#
.....
#####
....#
...##
""" |> strip

@assert f(tdata) == (8, (3, 4))

tdata = """
......#.#.
#..#.#....
..#######.
.#.#.###..
.#..#.....
..#....#.#
#..#....#.
.##.#..###
##...#..#.
.#....####
"""

@assert f(tdata) == (33, (5, 8))


tdata = """
#.#...#.#.
.###....#.
.#....#...
##.#.#.#.#
....#.#.#.
.##..###.#
..#...##..
..##....##
......#...
.####.###.
"""

@assert f(tdata) == (35, (1, 2))

tdata = """
.#..#..###
####.###.#
....###.#.
..###.##.#
##.##.#.#.
....###..#
..#.#..#.#
#..#.#.###
.##...##.#
.....#.#..
"""

@assert f(tdata) == (41, (6, 3))

tdata = """
.#..##.###...#######
##.############..##.
.#.######.########.#
.###.#######.####.#.
#####.##.#.##.###.##
..#####..#.#########
####################
#.####....###.#.#.##
##.#################
#####.##.###..####..
..######..##.#######
####.##.####...##..#
.#####..#.######.###
##...#.##########...
#.##########.#######
.####.#.###.###.#.##
....##.##.###..#####
.#.#.###########.###
#.#.#.#####.####.###
###.##.####.##.#..##
"""

@assert f(tdata) == (210, (11, 13))

@assert f(data) == (260, (14, 17))
