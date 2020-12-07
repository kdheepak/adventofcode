readInput() = strip(read(joinpath(@__DIR__, "./input.txt"), String))

part1(data = readInput()) = length(calculate1(data, Set(["shiny gold"]))) - 1

part2(data = readInput()) = calculate2(data, "shiny gold")


function calculate1(data, valid_bags)
    old = copy(valid_bags)
    for rule in split(strip(data), '\n', keepempty = false)
        bag, contents = split(rule, "bags contain")
        contents = replace(contents, "no other bags" => "")
        bags = split(contents, ", ", keepempty = false)
        for b in bags
            b = replace(b, "." => "")
            b = replace(b, "bags" => "")
            b = replace(b, "bag" => "")
            b = strip(b)
            if b == ""
                continue
            end
            b = join(split(b)[2: end], " ")
            if issubset([b], valid_bags)
                push!(valid_bags, strip(bag))
            end
        end
    end
    if length(old) == length(valid_bags)
        return valid_bags
    else
        return calculate1(data, valid_bags)
    end
end

function calculate2(data, bag_in_interest)
    counter = 0
    for rule in split(strip(data), '\n', keepempty = false)
        bag, contents = split(rule, "bags contain")
        bag = strip(bag)
        if bag  == bag_in_interest
            contents = replace(contents, "no other bags" => "")
            bags = split(contents, ", ", keepempty = false)
            for b in bags
                b = replace(b, "." => "")
                b = replace(b, "bags" => "")
                b = replace(b, "bag" => "")
                b = strip(b)
                if b == ""
                    continue
                end
                n_bags = parse(Int, split(b)[1])
                b = join(split(b)[2: end], " ")
                n = n_bags + n_bags * calculate2(data, b)
                counter += n
            end
        end
    end
    counter
end
