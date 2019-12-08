data = read(joinpath(@__DIR__, "../data/day08.txt"), String)

wide = 25
tall = 6

tdata = "123456789012"

function layers(data, wide, tall)
    l = [
    data[layer:layer+(wide*tall)-1] for layer in 1:(wide*tall):length(data)
    ]
    image_layers = []
    for (i, il) in enumerate(l)
        push!(image_layers, [
            [parse(Int, x) for x in (il[j:j+wide-1])] for j in 1:wide:length(il)
        ])
    end
    return image_layers
end

layers(tdata, 3, 2)

minz = Inf
minl = nothing
LAYERS = layers(data, wide, tall)
for l in LAYERS
    global minz
    global minl
    z = 0
    for il in l
        z += count(x -> x==0, [i for i in il])
    end
    if min(minz, z) < minz
        minl = l
        minz = min(minz, z)
    end
end

ones = sum(count(x -> x==1, [i for i in l]) for l in minl)
twos = sum(count(x -> x==2, [i for i in l]) for l in minl)

function merge(layer1::Vector{Vector{Int}}, layer2::Vector{Vector{Int}})
    new_layer = Vector{Int}[]
    for (line1, line2) in zip(layer1, layer2)
        push!(new_layer, [
            merge(b1, b2) for (b1, b2) in zip(line1, line2)
        ])
    end
    return new_layer
end

function merge(bit1::Int, bit2::Int)
    if bit1 == 0 || bit1 == 1
        return bit1
    elseif bit2 == 0 || bit2 == 1
        return bit2
    else
        return 2
    end
end

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
