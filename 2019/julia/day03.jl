using SparseArrays

data = open(joinpath(@__DIR__, "./../data/day03.txt")) do f
    readlines(f)
end

# data = ["R8,U5,L5,D3", "U7,R6,D4,L4"]

# data = ["R75,D30,R83,U83,L12,D49,R71,U7,L72", "U62,R66,U55,R34,D71,R55,D58,R83"]

# data = ["R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51", "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"]

line1 = data[1]
line2 = data[2]

POINTS = []
STEPS = []

function find_distances(matrix)
    distances = []
    S, _ = size(matrix)
    for i in findall((x) -> x == 2, matrix)
        push!(distances, distance(S, i.I...))
        push!(POINTS, i.I)
    end
    sort!(distances)
    distances
end

distance(S, x, y) = abs(Int(S/2) - x) + abs(Int(S/2) - y)

function points!(matrix, line)
    S, _ = size(matrix)
    x = Int(S / 2)
    y = Int(S / 2)
    matrix[x, y] = 1
    steps = 0
    for direction in split(line, ',')

        if occursin("R", direction)
            d = replace(direction, "R"=>"")
            for _ in 1:parse(Int, d)
                x += 1
                matrix[x, y] = 1
                steps += 1
                if (x,y) in POINTS
                    push!(STEPS, (x,y, steps))
                end
            end
        end

        if occursin("L", direction)
            d = replace(direction, "L"=>"")
            for _ in 1:parse(Int, d)
                x -= 1
                matrix[x, y] = 1
                steps += 1
                if (x,y) in POINTS
                    push!(STEPS, (x,y, steps))
                end
            end
        end

        if occursin("U", direction)
            d = replace(direction, "U"=>"")
            for _ in 1:parse(Int, d)
                y += 1
                matrix[x, y] = 1
                steps += 1
                if (x,y) in POINTS
                    push!(STEPS, (x,y, steps))
                end
            end
        end

        if occursin("D", direction)
            d = replace(direction, "D"=>"")
            for _ in 1:parse(Int, d)
                y -= 1
                matrix[x, y] = 1
                steps += 1
                if (x,y) in POINTS
                    push!(STEPS, (x,y, steps))
                end
            end
        end

    end

    push!(STEPS, ())

    return matrix

end


function run(S=100000)

    matrix1 = sparse([S], [S], 0)
    points!(matrix1, line1)

    matrix2 = sparse([S], [S], 0)
    steps2 = sparse([S], [S], 0)
    points!(matrix2, line2)

    matrix1 + matrix2

end

@show find_distances(run())

@time find_distances(run())

popfirst!(STEPS)
popfirst!(STEPS)

A = []
B = []
TEMP = A

for e in STEPS
    global TEMP
    if e == ()
        TEMP = B
        continue
    end
    push!(TEMP, e)
end

temp = []
for (x1,y1,v1) in A
for (x2,y2,v2) in B
if x1 == x2 && y1 == y2
push!(temp, v1 + v2)
end
end
end
sort!(temp)

