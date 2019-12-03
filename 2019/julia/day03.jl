data = open(joinpath(@__DIR__, "./../data/day03.txt")) do f
    readlines(f)
end

line1 = data[1]
line2 = data[2]

directionX = Dict('L' => 1, 'R' => -1, 'U' => 0, 'D' => 0)
directionY = Dict('L' => 0, 'R' => 0, 'U' => 1, 'D' => -1)

function points(line)
    x = 0
    y = 0
    length = 0
    ans = Dict{Tuple{Int, Int}, Int}()
    for d in split(line, ',')
        for _ in 1:parse(Int, d[2:end])
            x += directionX[d[1]]
            y += directionY[d[1]]
            length += 1
            if !((x,y) in keys(ans))
                ans[(x,y)] = length
            end
        end
    end
    return ans
end


function run()

    A = points(line1)
    B = points(line2)

    minimum([(abs(k1) + abs(k2)) for (k1, k2) in intersect(keys(A), keys(B))])

    minimum([(A[k] + B[k]) for k in intersect(keys(A), keys(B))])

end

