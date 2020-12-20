using DataStructures

readInput() = strip(read(joinpath(@__DIR__, "./input.txt"), String))

part1(data = readInput()) = f(strip(data))

part2(data = readInput()) = nothing


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
    for side1 in [grid1[begin, :], grid1[end, :], grid1[:, begin], grid1[:, end],
                  reverse(grid1[begin, :]), reverse(grid1[end, :]), reverse(grid1[:, begin]), reverse(grid1[:, end])]
        for side2 in [grid2[begin, :], grid2[end, :], grid2[:, begin], grid2[:, end],
                      reverse(grid2[begin, :]), reverse(grid2[end, :]), reverse(grid2[:, begin]), reverse(grid2[:, end])]
            s1 = join(side1)
            s2 = join(side2)
            push!(counter, side1 == side2)
        end
    end
    count(counter)
end
