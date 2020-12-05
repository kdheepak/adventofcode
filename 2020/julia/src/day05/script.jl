readInput() = strip(read(joinpath(@__DIR__, "./input.txt"), String))

seat_id(seat) = row(seat) * 8 + col(seat)

function row(seat)
    min, max = 0, 127
    for c in seat[1:7]
        limit = (max - min + 1) / 2 - 1
        if c == 'F'
            max = min + limit
        elseif c == 'B'
            min = min + limit + 1
        else
            error("not expected to be here: $c")
        end
    end
    return min
end

function col(seat)
    min, max = 0, 7
    for c in seat[end-2:end]
        limit = (max - min + 1) / 2 - 1
        if c == 'L'
            max = min + limit
        elseif c == 'R'
            min = min + limit + 1
        else
            error("not expected to be here: $c")
        end
    end
    return min
end

function part1(data = readInput())
    data = split(data, '\n')
    maximum([seat_id.(seat) for seat in data])
end

function part2(data = readInput())
    data = split(data, '\n')
    my_seat_id = 0
    seat_ids = sort(collect(Set([seat_id.(seat) for seat in data])))
    for s in minimum(seat_ids):maximum(seat_ids)
        if s ∉ seat_ids
            println(s)
        end
    end
end
