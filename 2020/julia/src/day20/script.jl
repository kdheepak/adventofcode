using DataStructures

readInput() = strip(read(joinpath(@__DIR__, "./input.txt"), String))

part1(data = readInput()) = f(strip(data))

part2(data = readInput()) = g(strip(data))


function f(data)
    images = split(data, "\n\n")
    images
    tiles = Dict{Int, Matrix}()
    for data in images
        tile = parse(Int, match(r"Tile (\d+):", split(data, '\n')[1])[1])
        data = permutedims(reduce(hcat, collect.(split(data, '\n')[2:end])))
        tiles[tile] = data
    end
    counter = DefaultDict{Int, Int}(0)
    for (tile1, data1) in tiles
        for (tile2, data2) in tiles
            tile1 == tile2 && continue
            if compare_edges(data1, data2) > 0
                counter[tile1] += 1
            end
        end
    end
    prod([k for (k,v) in counter if v == 2])
end

function compare_edges(grid1, grid2)
    w, h = size(grid1)
    counter = Bool[]
    for (i, side1) in enumerate([grid1[begin, :], grid1[end, :], grid1[:, begin], grid1[:, end],
                  reverse(grid1[begin, :]), reverse(grid1[end, :]), reverse(grid1[:, begin]), reverse(grid1[:, end])])
        for (j, side2) in enumerate([grid2[begin, :], grid2[end, :], grid2[:, begin], grid2[:, end]])
            s1 = join(side1)
            s2 = join(side2)
            push!(counter, side1 == side2)
        end
    end
    count(counter)
end

function g(data)
    images = split(data, "\n\n")
    images
    tiles = Dict{Int, Matrix}()
    for data in images
        tile = parse(Int, match(r"Tile (\d+):", split(data, '\n')[1])[1])
        data = permutedims(reduce(hcat, collect.(split(data, '\n')[2:end])))
        tiles[tile] = data
    end
    counter = DefaultDict{Int, Int}(0)
    for (tile1, data1) in tiles
        for (tile2, data2) in tiles
            tile1 == tile2 && continue
            if compare_edges(data1, data2) > 0
                counter[tile1] += 1
            end
        end
    end
    corners = [tiles[k] for (k,v) in counter if v == 2]
    edges = [tiles[k] for (k,v) in counter if v == 3]
    center = [tiles[k] for (k,v) in counter if v == 4]

    SIZE = √(length(corners) + length(edges) + length(center))

    picture = Dict()

    picture[(1,1)] = popfirst!(corners)

    # top left
    current_piece = picture[(1,1)]

    # fill top left triangle
    ep = [(i, edge_piece) for (i, edge_piece) in enumerate(edges) if compare_edges(current_piece, edge_piece) >= 1]
    picture[1,2], picture[2,1] = [e for (i,e) in ep]
    deleteat!(edges, [i for (i,e) in ep])

    # first row
    for i in 2:(SIZE-2)
        current_piece = picture[(1,i)]
        ep = [(i, edge_piece) for (i, edge_piece) in enumerate(edges) if compare_edges(current_piece, edge_piece) >= 1]
        picture[(1,i+1)] = only([e for (i, e) in ep])
        deleteat!(edges, [i for (i,e) in ep])
    end

    # first column
    for i in 2:(SIZE-2)
        current_piece = picture[(i,1)]
        ep = [(i, edge_piece) for (i, edge_piece) in enumerate(edges) if compare_edges(current_piece, edge_piece) >= 1]
        picture[(i+1, 1)] = only([e for (i, e) in ep])
        deleteat!(edges, [i for (i,e) in ep])
    end

    # top right
    current_piece = picture[(1,SIZE-1)]
    ps = [(i, corner_piece) for (i, corner_piece) in enumerate(corners) if compare_edges(current_piece, corner_piece) >= 1]
    i, p = only(ps)
    deleteat!(corners, i)
    picture[(1, SIZE)] = p

    # bottom left
    current_piece = picture[(SIZE-1,1)]
    ps = [(i, corner_piece) for (i, corner_piece) in enumerate(corners) if compare_edges(current_piece, corner_piece) >= 1]
    i, p = only(ps)
    deleteat!(corners, i)
    picture[(SIZE, 1)] = p

    # bottom right
    current_piece = picture[(SIZE-1,1)]
    picture[(SIZE, SIZE)] = only(corners)
    deleteat!(corners, 1)

    # fill bottom left edge
    current_piece = picture[(SIZE,1)]
    ep = [(i, edge_piece) for (i, edge_piece) in enumerate(edges) if compare_edges(current_piece, edge_piece) >= 1]
    picture[SIZE,2] = only([e for (i,e) in ep])
    deleteat!(edges, [i for (i,e) in ep])

    # last row
    for i in 2:(SIZE-2)
        current_piece = picture[(SIZE,i)]
        ep = [(i, edge_piece) for (i, edge_piece) in enumerate(edges) if compare_edges(current_piece, edge_piece) >= 1]
        picture[(SIZE,i+1)] = only([e for (i, e) in ep])
        deleteat!(edges, [i for (i,e) in ep])
    end

    # fill top right edge
    current_piece = picture[(1,SIZE)]
    ep = [(i, edge_piece) for (i, edge_piece) in enumerate(edges) if compare_edges(current_piece, edge_piece) >= 1]
    picture[2,SIZE] = only([e for (i,e) in ep])
    deleteat!(edges, [i for (i,e) in ep])

    # last column
    for i in 2:(SIZE-2)
        current_piece = picture[(i,SIZE)]
        ep = [(i, edge_piece) for (i, edge_piece) in enumerate(edges) if compare_edges(current_piece, edge_piece) >= 1]
        picture[(i+1, SIZE)] = only([e for (i, e) in ep])
        deleteat!(edges, [i for (i,e) in ep])
    end

    picture[1,1] = reverse(reverse(picture[1,1], dims=1), dims = 2)

    for col in 2:SIZE
        current = picture[1, col-1]
        picture[1,col] = find_picture(current[end, :], picture[1,col])
    end

    # all centers
    for j in 1:(SIZE-2)
        for i in 2:(SIZE-1)
            current_piece = picture[(j,i)]
            matches = [(i,p) for (i,p) in enumerate(center) if compare_edges(current_piece, p) >= 1]
            d, p = only(matches)
            deleteat!(center, d)
            picture[(j+1,i)] = p
        end
    end

    for row in 2:SIZE
        picture[row,1] = permutedims(find_picture(picture[row-1, 1][:, end], picture[row, 1]))
    end

    for row in 2:SIZE
        for col in 2:SIZE
            current = picture[row, col-1]
            picture[row,col] = find_picture(current[end, :], picture[row,col])
        end
    end

    # visualize(picture)
    final_grid = Vector{Char}[]
    w, h = size(picture[1,1])
    for prow in 1:SIZE
        for j in 2:h-1
            row = Char[]
            for pcol in 1:SIZE
                for i in 2:w-1
                    push!(row, picture[prow, pcol][i, j])
                end
            end
            push!(final_grid, row)
        end
    end
    final_grid = reduce(hcat, final_grid)
    grid = final_grid
    grid = reverse(permutedims(grid), dims = 2)
    sink_monsters!(grid)
    count(x -> x == '#', grid)
end

function sink_monsters!(grid)
    w, h = size(grid)
    found = 0
    for i in 2:(w-1), j in 1:(h - 19)
        if grid[j      , i     ] == '#' &&
           grid[j + 1  , i + 1 ] == '#' &&
           grid[j + 4  , i + 1 ] == '#' &&
           grid[j + 5  , i     ] == '#' &&
           grid[j + 6  , i     ] == '#' &&
           grid[j + 7  , i + 1 ] == '#' &&
           grid[j + 10 , i + 1 ] == '#' &&
           grid[j + 11 , i     ] == '#' &&
           grid[j + 12 , i     ] == '#' &&
           grid[j + 13 , i + 1 ] == '#' &&
           grid[j + 16 , i + 1 ] == '#' &&
           grid[j + 17 , i     ] == '#' &&
           grid[j + 18 , i     ] == '#' &&
           grid[j + 19 , i     ] == '#' &&
           grid[j + 18 , i - 1 ] == '#'
        grid[j      , i     ] = '.'
        grid[j + 1  , i + 1 ] = '.'
        grid[j + 4  , i + 1 ] = '.'
        grid[j + 5  , i     ] = '.'
        grid[j + 6  , i     ] = '.'
        grid[j + 7  , i + 1 ] = '.'
        grid[j + 10 , i + 1 ] = '.'
        grid[j + 11 , i     ] = '.'
        grid[j + 12 , i     ] = '.'
        grid[j + 13 , i + 1 ] = '.'
        grid[j + 16 , i + 1 ] = '.'
        grid[j + 17 , i     ] = '.'
        grid[j + 18 , i     ] = '.'
        grid[j + 19 , i     ] = '.'
        grid[j + 18 , i - 1 ] = '.'
        end
    end
    found

end

function find_monsters(grid)
    w, h = size(grid)
    found = 0
    for i in 2:(w-1), j in 1:(h - 19)
        if grid[j      , i     ] == '#' &&
           grid[j + 1  , i + 1 ] == '#' &&
           grid[j + 4  , i + 1 ] == '#' &&
           grid[j + 5  , i     ] == '#' &&
           grid[j + 6  , i     ] == '#' &&
           grid[j + 7  , i + 1 ] == '#' &&
           grid[j + 10 , i + 1 ] == '#' &&
           grid[j + 11 , i     ] == '#' &&
           grid[j + 12 , i     ] == '#' &&
           grid[j + 13 , i + 1 ] == '#' &&
           grid[j + 16 , i + 1 ] == '#' &&
           grid[j + 17 , i     ] == '#' &&
           grid[j + 18 , i     ] == '#' &&
           grid[j + 19 , i     ] == '#' &&
           grid[j + 18 , i - 1 ] == '#'
            found += 1
        end
    end
    found

end

function find_picture(match_col, grid)
    if match_col == grid[begin, :]
        # @show 1
        return grid
    elseif match_col == reverse(grid[begin, :])
        # @show 2
        return reverse(grid, dims = 2)
    elseif match_col == grid[end, :]
        # @show 3
        return reverse(grid, dims = 1)
    elseif match_col == reverse(grid[end, :])
        # @show 4
        return reverse(reverse(grid, dims = 2), dims = 1)
    elseif match_col == grid[:, begin]
        # @show 5
        return permutedims(grid)
    elseif match_col == grid[:, end]
        # @show 6
        return reverse(permutedims(grid), dims = 1)
    elseif match_col == reverse(grid[:, begin])
        # @show 7
        return reverse(permutedims(grid), dims = 2)
    elseif match_col == reverse(grid[:, end])
        # @show 8
        return reverse(permutedims(reverse(grid, dims=2)), dims = 2)
    else
        error("What")
    end
end

function visualize(picture::Dict)
    w, h = size(picture[1,1])
    for prow in 1:12
        for j in 1:h
            for pcol in 1:12
                for i in 1:w
                    print(picture[prow, pcol][i, j])
                end
                print(" ")
            end
            println()
        end
        println()
    end
end

function visualize(grid::Matrix)
    w, h = size(grid)
    for j in 1:h
        for i in 1:w
            grid[i, j] == '.' ? print(".") : print(grid[i, j])
        end
        println()
    end
end
