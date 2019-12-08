using Crayons

data = read(joinpath(@__DIR__, "../data/day08.txt"), String)

tdata = "123456789012"

function layers(data, wide, tall)
    data = strip(data)
    l = [
        [parse(Int, x) for x in data[i:i+(wide*tall)-1]] for i in 1:(wide*tall):length(data)
    ]
    image_layers = Vector{Vector{Int}}[]
    for (i, il) in enumerate(l)
        push!(image_layers, [
            [x for x in (il[j:j+wide-1])] for j in 1:wide:length(il)
        ])
    end
    return image_layers
end

@assert layers(tdata, 3, 2) == [
    [[1, 2, 3], [4, 5, 6]],
    [[7, 8, 9], [0, 1, 2]]
]

wide = 25
tall = 6
LAYERS = layers(data, wide, tall)

function corruption_check(layers)
    minz = Inf
    minl = nothing
    for l in layers
        z = sum(count(x -> x==0, il) for il in l)
        if min(minz, z) < minz
            minz = min(minz, z)
            minl = l
        end
    end
    ones = sum(count(x -> x==1, l) for l in minl)
    twos = sum(count(x -> x==2, l) for l in minl)
    return ones * twos
end

@assert corruption_check(LAYERS) == 828

function merge(layer1::Vector{Vector{Int}}, layer2::Vector{Vector{Int}})
    new_layer = Vector{Int}[]
    for (line1, line2) in zip(layer1, layer2)
        push!(new_layer, [
            merge(b1, b2) for (b1, b2) in zip(line1, line2)
        ])
    end
    return new_layer
end

merge(pixel1::Int, pixel2::Int) = (pixel1 == 0 || pixel1 == 1) ? pixel1 : (pixel2 == 0 || pixel2 == 1) ? pixel2 : 2

for x in foldl(merge, LAYERS)
    for c in x
        if c == 0
            print(Crayon(), " ", Crayon(reset = true))
        elseif c == 1
            print(Crayon(background = :black), " ", Crayon(reset = true))
        end
    end
    println()
end
