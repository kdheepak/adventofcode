readInput() = strip(read(joinpath(@__DIR__, "./input.txt"), String))

function part1(data = readInput())
    mapreduce(+, split(data, "\n\n")) do group
        questions = split(group, '\n', keepempty=false)
        length(union(Set.(questions)...))
    end
end

function part2(data = readInput())
    mapreduce(+, split(data, "\n\n")) do group
        questions = split(group, '\n', keepempty=false)
        length(intersect(Set.(questions)...))
    end
end
