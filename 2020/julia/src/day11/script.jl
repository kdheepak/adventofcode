readInput() = strip(read(joinpath(@__DIR__, "./input.txt"), String))

part1(data = readInput()) = f(data)

part2(data = readInput()) = g(data)


function f(data)
    grid = permutedims(reduce(hcat, collect.(split(data, '\n'))))
    while true
        old_grid = copy(grid)
        sim1(grid)
        if grid == old_grid
            break
        end
    end
    count(x -> x == '#', grid)
end

function g(data)
    grid = permutedims(reduce(hcat, collect.(split(data, '\n'))))
    while true
        old_grid = copy(grid)
        sim2(grid)
        if grid == old_grid
            break
        end
    end
    count(x -> x == '#', grid)
end

function sim1(grid)
    rows, cols = size(grid)
    old_grid = copy(grid)
    for r in 1:rows, c in 1:cols
        A = adjacent_seats1(old_grid, r, c)
        grid[r, c] == 'L' && count(x -> x == '#', A) == 0 && ( grid[r, c] = '#' )
        grid[r, c] == '#' && count(x -> x == '#', A) >= 4 && ( grid[r, c] = 'L' )
    end
end

function sim2(grid)
    rows, cols = size(grid)
    old_grid = copy(grid)
    for r in 1:rows, c in 1:cols
        A = adjacent_seats2(old_grid, r, c)
        grid[r, c] == 'L' && count(x -> x == '#', A) == 0 && ( grid[r, c] = '#' )
        grid[r, c] == '#' && count(x -> x == '#', A) >= 5 && ( grid[r, c] = 'L' )
    end
end

function adjacent_seats1(grid, i, j)
    A = []
    for xy in CartesianIndex.([(i-1, j-1), (i-1, j+1), (i+1, j-1), (i+1, j+1), (i-1, j), (i+1, j), (i, j-1), (i, j+1)])
        checkbounds(Bool, grid, xy) && push!(A, grid[xy])
    end
    A
end

function adjacent_seats2(grid, i, j)
    A = []
    for direction in CartesianIndex.([(-1,-1), (-1,+1), (+1,-1), (+1, +1), (-1,0), (+1,0), (0,-1), (0,+1)])
        xy = CartesianIndex(i, j) + direction
        while checkbounds(Bool, grid, xy) && grid[xy] == '.'
            xy += direction
        end
        checkbounds(Bool, grid, xy) && push!(A, grid[xy])
    end
    A
end
