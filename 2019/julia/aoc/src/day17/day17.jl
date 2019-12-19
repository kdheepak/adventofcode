readInput() = read(joinpath(@__DIR__, "./input.txt"), String)

include("../vm.jl")

part2(data = readInput()) = nothing

function build_view()
    vm = VM(readInput())
    run!(vm)
    o = output(vm)
    s = join([Char(x) for x in o])
    return reshape([c for c in replace(s, "\n"=>"")], length(split(s)[1]), :)
end

function part1(data = readInput())
    alignment = 0
    view = build_view()
    x, y = size(view)
    for j in 2:y-1
        for i in 2:x-1
            if view[i, j] == '#' &&
                view[i+1, j] == '#' &&
                view[i, j+1] == '#' &&
                view[i-1, j] == '#' &&
                view[i, j-1] == '#'
                alignment += (i-1)*(j-1)
            end
        end
    end
    return alignment
end
