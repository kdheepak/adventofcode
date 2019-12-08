using Crayons

data = read(joinpath(@__DIR__, "../data/day08.txt"), String)

tdata = "123456789012"

layers(data::String, wide, tall) = layers(Int[parse(Int, i) for i in strip(data)], wide, tall)
layers(data::Vector{Int}, wide, tall) = reshape(data, wide, tall, length(data) ÷ (wide * tall))

LAYERS = layers(data, 25, 6)

function corruption_check(layers)
    minz = Inf
    minl = nothing
    for il in 1:size(layers)[3]
        l = layers[:, :, il]'
        z = count(x -> x==0, l)
        if min(minz, z) < minz
            minz = min(minz, z)
            minl = l
        end
    end
    ones = count(x -> x==1, minl)
    twos = count(x -> x==2, minl)
    return ones * twos
end

@assert layers(tdata, 3, 2)[:, :, 1] == [1 2 3; 4 5 6]'
@assert layers(tdata, 3, 2)[:, :, 2] == [7 8 9; 0 1 2]'

@assert corruption_check(LAYERS) == 828

merge(layer1::Matrix{Int}, layer2::Matrix{Int}) = reshape([merge(p1, p2) for (p1, p2) in zip(layer1, layer2)], size(layer1)...)
merge(pixel1::Int, pixel2::Int) = (pixel1 == 0 || pixel1 == 1) ? pixel1 : (pixel2 == 0 || pixel2 == 1) ? pixel2 : 2

function draw(image)
    result = foldl(merge, [image[:, :, z] for z in 1:size(image)[3]])'
    rows, cols = size(result)
    for row in 1:rows
        for col in 1:cols
            c = result[row, col]
            c == 0 ? print(Crayon(), " ", Crayon(reset = true)) :
            c == 1 ? print(Crayon(background = :black), " ", Crayon(reset = true)) :
            error("c != 1 || c != 0 : c = $c")
        end
        println()
    end
end

draw(LAYERS)
