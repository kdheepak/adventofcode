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

    grid = Dict{Complex, Bool}()
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
            reference += round(exp(im * 0), digits = 2)
        elseif n == NorthEast()
            reference += round(exp(im * π / 3), digits = 2)
        elseif n == NorthWest()
            reference += round(exp(im * 2π / 3), digits = 2)
        elseif n == West()
            reference += round(exp(im * π), digits = 2)
        elseif n == SouthWest()
            reference += round(exp(im * ( π + π / 3 )), digits = 2)
        elseif n == SouthEast()
            reference += round(exp(im * ( π + 2π / 3 )), digits = 2)
        else
            error("wat")
        end
    end
    reference = round(reference, digits = 2)
    reference ∉ keys(grid) && ( grid[reference] = false )
    grid[reference] = !grid[reference]
end

function has_neighbour(grid, k)
    directions = [
        round(exp(im * 0), digits = 2),
        round(exp(im * π / 3), digits = 2),
        round(exp(im * 2π / 3), digits = 2),
        round(exp(im * π), digits = 2),
        round(exp(im * ( π + π / 3 )), digits = 2),
        round(exp(im * ( π + 2π / 3 )), digits = 2),
    ]
    for n in directions
        c = round(n + k, digits = 2)
        c ∈ keys(grid) && return true
    end
    return false
end

function g(data)
    tiles = split(data, '\n')
    tiles = find_steps.(tiles)

    grid = Dict{Complex, Bool}()
    for tile in tiles
        flip!(grid, tile)
    end

    directions = [
        round(exp(im * 0), digits = 2),
        round(exp(im * π / 3), digits = 2),
        round(exp(im * 2π / 3), digits = 2),
        round(exp(im * π), digits = 2),
        round(exp(im * ( π + π / 3 )), digits = 2),
        round(exp(im * ( π + 2π / 3 )), digits = 2),
    ]

    [delete!(grid, k) for k in keys(grid) if !grid[k]]

    day = 1
    while day <= 100
        for k in keys(grid), n in directions
            c = round(k + n, digits = 2)
            if c ∉ keys(grid) && has_neighbour(grid, c)
                grid[c] = false
            end
        end

        flipped = Complex[]
        for k in keys(grid)
            counter = count([grid[round(k + n, digits = 2)] for n in directions if round(k + n, digits = 2) ∈ keys(grid)])
            if grid[k]
                ( counter == 0 || counter > 2 ) && push!(flipped, k)
            else
                counter == 2 && push!(flipped, k)
            end
        end
        for k in flipped
            grid[k] = !grid[k]
        end
        [delete!(grid, k) for k in keys(grid) if !grid[k]]
        println("Day $day: $(count(values(grid)))")
        day += 1
    end
    count(values(grid))
end
