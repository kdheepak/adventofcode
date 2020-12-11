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
        if grid[r, c] == 'L' && count(x -> x == '#', A) == 0
            grid[r, c] = '#'
        elseif grid[r, c] == '#' && count(x -> x == '#', A) >= 4
            grid[r, c] = 'L'
        end
    end
end

function sim2(grid)
    rows, cols = size(grid)
    old_grid = copy(grid)
    for r in 1:rows, c in 1:cols
        A = adjacent_seats2(old_grid, r, c)
        if grid[r, c] == 'L' && count(x -> x == '#', A) == 0
            grid[r, c] = '#'
        elseif grid[r, c] == '#' && count(x -> x == '#', A) >= 5
            grid[r, c] = 'L'
        end
    end
end

function adjacent_seats1(grid, i, j)
    A = []
    R = size(grid, 1)
    C = size(grid, 2)
    i > 1 && j > 1 && push!(A, grid[i - 1, j - 1])
    i > 1 && j < C && push!(A, grid[i - 1, j + 1])
    i < R && j > 1 && push!(A, grid[i + 1, j - 1])
    i < R && j < C && push!(A, grid[i + 1, j + 1])
    i > 1 && push!(A, grid[i - 1, j])
    i < R && push!(A, grid[i + 1, j])
    j > 1 && push!(A, grid[i, j - 1])
    j < C && push!(A, grid[i, j + 1])

    A
end

function adjacent_seats2(grid, i, j)
    A = []

    R = size(grid, 1)
    C = size(grid, 2)

    counter = 1
    while i > counter && j > counter && grid[i - counter, j - counter] == '.'
        counter += 1
    end
    i > counter && j > counter && push!(A, grid[i - counter, j - counter])

    counter = 1
    while i > counter && j < C - counter + 1 && grid[i - counter, j + counter] == '.'
        counter += 1
    end
    i > counter && j < C - counter + 1 && push!(A, grid[i - counter, j + counter])

    counter = 1
    while i < R - counter + 1 && j > counter && grid[i + counter, j - counter] == '.'
        counter += 1
    end
    i < R - counter + 1 && j > counter && push!(A, grid[i + counter, j - counter])

    counter = 1
    while i < R - counter + 1 && j < C  - counter + 1 && grid[i + counter, j + counter] == '.'
        counter += 1
    end
    i < R - counter + 1 && j < C  - counter + 1 && push!(A, grid[i + counter, j + counter])

    counter = 1
    while i > counter && grid[i - counter, j] == '.'
        counter += 1
    end
    i > counter && push!(A, grid[i - counter, j])

    counter = 1
    while i < R - counter + 1 && grid[i + counter, j] == '.'
        counter += 1
    end
    i < R - counter + 1 && push!(A, grid[i + counter, j])

    counter = 1
    while j > counter && grid[i, j - counter] == '.'
        counter += 1
    end
    j > counter && push!(A, grid[i, j - counter])

    counter = 1
    while j < C - counter + 1 && grid[i, j + counter] == '.'
        counter += 1
    end
    j < C - counter + 1 && push!(A, grid[i, j + counter])

    A
end
