using Test

readInput() = read(joinpath(@__DIR__, "./input.txt"), String)

const directionX = Dict('L' => 1, 'R' => -1, 'U' => 0, 'D' =>  0)
const directionY = Dict('L' => 0, 'R' =>  0, 'U' => 1, 'D' => -1)

function points(line)
    x = 0
    y = 0
    len = 0
    ans = Dict{Tuple{Int, Int}, Int}()
    for d in split(line, ',')
        for _ in 1:parse(Int, d[2:end])
            x += directionX[d[1]]
            y += directionY[d[1]]
            len += 1
            if (x,y) ∉ keys(ans)
                ans[(x,y)] = len
            end
        end
    end
    return ans
end

function part1(data = readInput())
    lines = split(strip(data), "\n")
    A = points(lines[1])
    B = points(lines[2])
    return minimum([(abs(k1) + abs(k2)) for (k1, k2) in keys(A) ∩ keys(B)])
end

function part2(data = readInput())
    lines = split(strip(data), "\n")
    A = points(lines[1])
    B = points(lines[2])
    return minimum([(A[k] + B[k]) for k in keys(A) ∩ keys(B)])
end

function runtests()
    @testset "Day 03: Part 1" begin
        tdata = """
        R8,U5,L5,D3
        U7,R6,D4,L4
        """
        @test part1(tdata) == 6

        tdata = """
        R75,D30,R83,U83,L12,D49,R71,U7,L72
        U62,R66,U55,R34,D71,R55,D58,R83
        """
        @test part1(tdata) == 159

        tdata = """
        R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
        U98,R91,D20,R16,D67,R40,U7,R15,U6,R7
        """
        @test part1(tdata) == 135

        @test part1() == 227
    end
    @testset "Day 03: Part 2" begin
        tdata = """
        R8,U5,L5,D3
        U7,R6,D4,L4
        """
        @test part2(tdata) == 30

        tdata = """
        R75,D30,R83,U83,L12,D49,R71,U7,L72
        U62,R66,U55,R34,D71,R55,D58,R83
        """
        @test part2(tdata) == 610

        tdata = """
        R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
        U98,R91,D20,R16,D67,R40,U7,R15,U6,R7
        """
        @test part2(tdata) == 410

        @test part2() == 20286
    end
end
