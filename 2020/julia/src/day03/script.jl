readInput() = read(joinpath(@__DIR__, "./input.txt"), String)

part1(data = readInput()) = nothing

part2(data = readInput()) = nothing

testInput() = """..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#"""

function tree_map(data=testInput)
    lines = split(strip(data), '\n')
    width = length(lines[1])
    map(lines) do line
        [x == '.' ? 0 : 1 for x in line]
    end
end

function count_trees(data = testInput(), slope = (3, 1))
    counter = 0
    layout = tree_map(data)
    width = 1
    slopeX, slopeY = slope
    println(slope)
    height = 1
    for height in (1+slopeY):slopeY:length(layout)
        width += slopeX
        if width > length(layout[1])
            width = width - length(layout[1])
        end
        counter += layout[height][width]
    end
    counter
end


function count_slopes(data = testInput())
    trees = 1
    slopes = [(1,1), (3,1), (5,1), (7,1), (1,2)]
    for slope in slopes
        t = count_trees(data, slope)
        println(slope, ": ", t)
        trees *= t
    end
    trees
end
