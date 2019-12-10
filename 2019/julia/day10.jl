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
    for c in 1:cols
        for r in 1:rows
            if x == c && y == r
                continue
            elseif data[c, r] == 1
                z = (x - c) + (y - r)*im
                z = round(z / abs(z), digits=4)
                if z ∉ keys(line_of_sight) || distance((c,r), (x, y)) < distance(line_of_sight[z], (x, y))
                    line_of_sight[z] = (c, r)
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
    )
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
    return max_asteroids, (px-1, py-1)
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

function sort_by_angles(z)
    angle = atand(z.re, z.im)
    if angle < 0
        angle += 360
    end
    return angle
end


tdata = g(tdata)
los = get_line_of_sight(tdata, 11+1, 13+1)
sorted_keys = sort([k for k in keys(los)], by = sort_by_angles)

@assert los[sorted_keys[1]] == (11 + 1, 12 + 1)
@assert los[sorted_keys[end]] == (12 + 1, 1 + 1)
@assert los[sorted_keys[end-1]] == (12 + 1, 2 + 1)
@assert los[sorted_keys[end-8]] == (12 + 1, 8 + 1)
@assert los[sorted_keys[end-18]] == (16 + 1, 0 + 1)
@assert los[sorted_keys[end-48]] == (16 + 1, 9 + 1)
@assert los[sorted_keys[end-98]] == (10 + 1, 16 + 1)
@assert los[sorted_keys[end-197]] == (9 + 1, 6 + 1)
@assert los[sorted_keys[end-198]] == (8 + 1, 2 + 1)
@assert los[sorted_keys[end-199]] == (10 + 1, 9 + 1)


data = g(data)
los = get_line_of_sight(data, 14+1, 17+1)
sorted_keys = sort([k for k in keys(los)], by = sort_by_angles)

x, y = los[sorted_keys[end-198]]
(x-1)*100 + (y-1)
