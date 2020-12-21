readInput() = strip(read(joinpath(@__DIR__, "./input.txt"), String))

part1(data = readInput()) = f(split(strip(data), '\n'))

part2(data = readInput()) = g(split(strip(data), '\n'))

function f(data)
    data = map(data) do line
        allergens, labels = strip.(split(line, '('))
        labels = strip(replace(replace(labels, ")" => ""), "contains " => ""))
        labels = strip.(split(labels, ",", keepempty = false))
        allergens = String.(split(allergens, " "))
        allergens, labels
    end
    no_allergens = Set{String}()
    for (allergens, _) in data
        for a in allergens
            push!(no_allergens, a)
        end
    end
    total = Dict()
    for (ingredients, labels) in data
        for label in labels
            if !haskey(total, label)
                total[label] = Set{String}(ingredients)
            else
                total[label] = intersect(total[label], ingredients)
            end
        end
    end
    flat = Set{String}()
    for v in values(total)
        for label in v
            push!(flat, label)
        end
    end
    no_allergens = setdiff(no_allergens, flat)
    r = map(data) do (ingredients, _)
        sum(ingredient ∈ no_allergens for ingredient in ingredients)
    end
    sum(r)
end

function g(data)
    data = map(data) do line
        allergens, labels = strip.(split(line, '('))
        labels = strip(replace(replace(labels, ")" => ""), "contains " => ""))
        labels = strip.(split(labels, ",", keepempty = false))
        allergens = String.(split(allergens, " "))
        allergens, labels
    end
    no_allergens = Set{String}()
    all_allergens = Set{String}()
    all_labels = Set{String}()
    for (allergens, labels) in data
        for a in allergens
            push!(no_allergens, a)
            push!(all_allergens, a)
        end
        for l in labels
            push!(all_labels, l)
        end
    end
    total = Dict()
    for (ingredients, labels) in data
        for label in labels
            if !haskey(total, label)
                total[label] = Set{String}(ingredients)
            else
                total[label] = intersect(total[label], ingredients)
            end
        end
    end
    flat = Set{String}()
    for v in values(total)
        for label in v
            push!(flat, label)
        end
    end
    no_allergens = setdiff(no_allergens, flat)
    interest = collect(keys(total))
    while true
        for label in interest
            if length(total[label]) == 1
                ingredient = only(total[label])
                for label_ in interest
                    if label_ != label
                        delete!(total[label_], ingredient)
                    end
                end
            end
        end
        all([length(v) == 1 for v in values(total)]) && break
    end
    join([only(total[k]) for k in sort(collect(keys(total)))], ',')
end
