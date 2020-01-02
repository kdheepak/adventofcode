readInput() = read(joinpath(@__DIR__, "./input.txt"), String)

include("../vm.jl")

function build_view(o)
    s = join([Char(x) for x in o])
    return reshape([c for c in replace(s, "\n"=>"")], length(split(s)[1]), :)
end

function get_alignment(view)
    sum_alignment_parameter = 0
    x, y = size(view)
    for j in 2:y-1
        for i in 2:x-1
            if view[i, j] == '#' &&
                view[i+1, j] == '#' &&
                view[i, j+1] == '#' &&
                view[i-1, j] == '#' &&
                view[i, j-1] == '#'
                sum_alignment_parameter += (i-1)*(j-1)
            end
        end
    end
    return sum_alignment_parameter
end

function part1(data = readInput())
    vm = VM(data)
    run!(vm)
    o = output(vm)
    view = build_view(o)
    return get_alignment(view)
end

function can_move_forward(view, x, y, dx, dy)

    X, Y = size(view)
    if !(1 <= (x + dx) <= X) || !(1 <= (y + dy) <= Y)
        # out of bounds
        return false
    end
    if view[x + dx, y + dy] != '#'
        return false
    end

    @assert view[x + dx, y + dy] == '#'

    return true

end

const DIRECTION = Dict{String, Tuple{Int, Int}}(
    "U" => (0, -1),
    "D" => (0, 1),
    "L" => (-1, 0),
    "R" => (1, 0),
)

function can_turn_left(view, dir, x, y)
    dx, dy = DIRECTION[turn_left(dir)]
    return can_move_forward(view, x, y, dx, dy)
end

function can_turn_right(view, dir, x, y)
    dx, dy = DIRECTION[turn_right(dir)]
    return can_move_forward(view, x, y, dx, dy)
end

function turn_left(current_dir)
    if current_dir == "U"
        current_dir = "L"
    elseif current_dir == "L"
        current_dir = "D"
    elseif current_dir == "D"
        current_dir = "R"
    elseif current_dir == "R"
        current_dir = "U"
    end
    return current_dir
end

function turn_right(current_dir)
    if current_dir == "U"
        current_dir = "R"
    elseif current_dir == "L"
        current_dir = "U"
    elseif current_dir == "D"
        current_dir = "L"
    elseif current_dir == "R"
        current_dir = "D"
    end
    return current_dir
end

function get_path(view)
    path = String[]
    # draw(view)
    index = findfirst(==('^'), view)
    x, y = index.I
    push!(path, "R")
    current_dir = "R"
    dx, dy = (1, 0)

    while true
        dx, dy = DIRECTION[current_dir]
        count = 0
        while can_move_forward(view, x, y, dx, dy)
            count += 1
            x += dx
            y += dy
        end
        push!(path, string(count))

        if can_turn_left(view, current_dir, x, y)
            push!(path, "L")
            current_dir = turn_left(current_dir)
        elseif can_turn_right(view, current_dir, x, y)
            push!(path, "R")
            current_dir = turn_right(current_dir)
        else
            break
        end

    end
    return join(path, ",")
end

function part2(data = readInput())
    vm = VM(data)
    run!(vm)
    o = output(vm)
    view = build_view(o)
    path = get_path(view)
    # Regex from https://old.reddit.com/r/adventofcode/comments/ebr7dg/2019_day_17_solutions/fb7ymcw/
    m = match(r"^(.{1,21})\1*(.{1,21})(?:\1|\2)*(.{1,21})(?:\1|\2|\3)*$", path * ",")
    main = replace(replace(replace(path * ",", m[1] => "A,"), m[2] => "B,"), m[3] => "C,")
    main = vcat(Int.(collect(main)[1:(end-1)]), Int('\n'))
    A = vcat(Int.(collect(m[1])[1:(end-1)]), Int('\n'))
    B = vcat(Int.(collect(m[2])[1:(end-1)]), Int('\n'))
    C = vcat(Int.(collect(m[3])[1:(end-1)]), Int('\n'))
    data = [c for c in data]
    data[1] = '2'
    data = join(data)
    vm = VM(data)
    @async run!(vm)
    for ins in main; put!(vm.input, ins); end
    for ins in A; put!(vm.input, ins); end
    for ins in B; put!(vm.input, ins); end
    for ins in C; put!(vm.input, ins); end
    for ins in [Int('n'), Int('\n')]; put!(vm.input, ins); end
    yield()
    return output(vm)[end]
end

draw(view) = println(join([join(view[:,x]) for x in 1:size(view)[2]], "\n"))

# ### Tests

using Test

function runtests()
    @testset "Day 17: Part 1" begin
        @test get_alignment(build_view("""
        ..#..........
        ..#..........
        #######...###
        #.#...#...#.#
        #############
        ..#...#...#..
        ..#####...^..
        """)) == 76
        @test part1() == 3936
    end

    @testset "Day 17: Part 2" begin
        @test part2() == 785733
    end
end

