using Test

readInput() = read(joinpath(@__DIR__, "./input.txt"), String)

layers(data::String, wide, tall) = layers(Int[parse(Int, i) for i in strip(data)], wide, tall)
layers(data::Vector{Int}, wide, tall) = reshape(data, wide, tall, length(data) ÷ (wide * tall))

function corruption_check(layers)
    slices = collect(eachslice(layers, dims=3))
    minl = slices[argmin([count(x -> x == 0, l) for l in slices])]
    return count(x -> x == 1, minl) * count(x -> x == 2, minl)
end

part1(data = readInput()) = corruption_check(layers(data, 25, 6))

merge(pixel1::Int, pixel2::Int) = pixel1 == 2 ? pixel2 : pixel1

function draw(image)
    io = IOBuffer()
    result = foldl((x, y) -> merge.(x, y), eachslice(image, dims=3))'
    rows, cols = size(result)
    for row in 1:rows, col in 1:cols
        c = result[row, col]
        c == 0 ? print(io, " ") :
        c == 1 ? print(io, "█") :
        error("c != 1 && c != 0 ; c = $c")
        if (col == cols) println(io) end
    end
    String(take!(io))
end

part2(data = readInput()) = draw(layers(data, 25, 6))

function runtests()
    @testset "Day 08: Part 1" begin
        tdata = "123456789012"
        @test layers(tdata, 3, 2)[:, :, 1] == [
            1 2 3
            4 5 6
        ]'
        @test layers(tdata, 3, 2)[:, :, 2] == [
            7 8 9
            0 1 2
        ]'
        @test part1() == 828
    end
    @testset "Day 08: Part 2" begin
        @test split(strip(part2())) == split(strip("""
████ █    ███    ██ ████
   █ █    █  █    █ █
  █  █    ███     █ ███
 █   █    █  █    █ █
█    █    █  █ █  █ █
████ ████ ███   ██  █
"""))
    end
end
