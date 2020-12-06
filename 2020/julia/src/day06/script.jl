readInput() = strip(read(joinpath(@__DIR__, "./input.txt"), String))

function part1(data = readInput())
    data = split(data, "\n\n")
    total = 0
    for group in data
        questions = split(group, '\n', keepempty=false)
        counter = Set()
        for question in questions
            for c in question
                push!(counter, c)
            end
        end
        total += length(counter)
    end
    total
end

function part2(data = readInput())
    data = split(data, "\n\n")
    total = 0
    for group in data
        questions = split(group, '\n', keepempty=false)
        counter_set = Set()
        for (i, question) in enumerate(questions)
            counter = Set()
            for c in question
                push!(counter, c)
            end
            if i == 1
                counter_set = counter
            else
                counter_set = intersect(counter_set, counter)
            end
        end
        total += length(counter_set)
    end
    total
end
