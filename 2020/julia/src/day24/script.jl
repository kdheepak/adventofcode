using DataStructures

readInput() = strip(read(joinpath(@__DIR__, "./input.txt"), String))

part1(data = readInput()) = f(strip(data))

part2(data = readInput()) = g(strip(data))

struct East end
struct SouthEast end
struct SouthWest end
struct West end
struct NorthWest end
struct NorthEast end

function f(data)
    tiles = split(data, '\n')
    tiles = find_steps.(tiles)

    grid = DefaultDict{Complex, Bool}(false)
    for tile in tiles
        flip!(grid, tile)
    end
    # @show grid
    count(values(grid))
end

function find_steps(tile)
    steps = []
    while length(tile) > 0
        if first(tile) == 'w'
            push!(steps, West())
            tile = tile[2:end]
        elseif first(tile) == 'e'
            push!(steps, East())
            tile = tile[2:end]
        elseif first(tile) == 'n' && first(tile[2:end]) == 'e'
            push!(steps, NorthEast())
            tile = tile[3:end]
        elseif first(tile) == 's' && first(tile[2:end]) == 'w'
            push!(steps, SouthWest())
            tile = tile[3:end]
        elseif first(tile) == 'n' && first(tile[2:end]) == 'w'
            push!(steps, NorthWest())
            tile = tile[3:end]
        elseif first(tile) == 's' && first(tile[2:end]) == 'e'
            push!(steps, SouthEast())
            tile = tile[3:end]
        end
    end
    steps
end

function flip!(grid, tiles)
    # display(tiles)
    reference = 1 + 1im
    for n in tiles
        if n == East()
            reference += round(exp(im * 0), digits = 4)
        elseif n == NorthEast()
            reference += round(exp(im * π / 3), digits = 4)
        elseif n == NorthWest()
            reference += round(exp(im * 2π / 3), digits = 4)
        elseif n == West()
            reference += round(exp(im * π), digits = 4)
        elseif n == SouthWest()
            reference += round(exp(im * ( π + π / 3 )), digits = 4)
        elseif n == SouthEast()
            reference += round(exp(im * ( π + 2π / 3 )), digits = 4)
        else
            error("wat")
        end
    end
    reference = round(reference, digits = 4)
    # @show reference, grid[reference], !grid[reference]
    grid[reference] = !grid[reference]
end

function g(data)
    tiles = split(data, '\n')
    tiles = find_steps.(tiles)

    grid = DefaultDict{Complex, Bool}(false)
    for tile in tiles
        flip!(grid, tile)
    end
    # @show grid
    minx, maxx = extrema([x.re for x in keys(grid)])
    miny, maxy = extrema([y.im for y in keys(grid)])
end
