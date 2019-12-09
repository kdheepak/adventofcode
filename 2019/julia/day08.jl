data = read(joinpath(@__DIR__, "../data/day08.txt"), String)

tdata = "123456789012"

layers(data::String, wide, tall) = layers(Int[parse(Int, i) for i in strip(data)], wide, tall)
layers(data::Vector{Int}, wide, tall) = reshape(data, wide, tall, length(data) ÷ (wide * tall))

LAYERS = layers(data, 25, 6)

function corruption_check(layers)
    minz = Inf
    minl = nothing
    for il in eachslice(layers, dims=3)
        l = il'
        z = count(x -> x == 0, l)
        if min(minz, z) < minz
            minz = min(minz, z)
            minl = l
        end
    end
    return count(x -> x == 1, minl) * count(x -> x == 2, minl)
end

@assert layers(tdata, 3, 2)[:, :, 1] == [1 2 3; 4 5 6]'
@assert layers(tdata, 3, 2)[:, :, 2] == [7 8 9; 0 1 2]'

@assert corruption_check(LAYERS) == 828

merge(pixel1::Int, pixel2::Int) = pixel1 == 2 ? pixel2 : pixel1

function draw(image, )
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

@assert split(strip(draw(LAYERS))) == split(strip("""
████ █    ███    ██ ████
   █ █    █  █    █ █
  █  █    ███     █ ███
 █   █    █  █    █ █
█    █    █  █ █  █ █
████ ████ ███   ██  █
"""))
