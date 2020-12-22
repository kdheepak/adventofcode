# https://adventofcode.com/2020/day/21

**Learnings**

Using `LightGraphs` and `LightGraphsFlows`:

```julia
using GraphRecipes, Plots
using LightGraphs
using LightGraphsFlows

readInput() = strip(read(joinpath(@__DIR__, "./input.txt"), String))

part1(data = readInput()) = f(split(strip(data), '\n'))

part2(data = readInput()) = g(split(strip(data), '\n'))

function f(data)
    data = map(data) do line
        ingredients, allergens = match(r"^(.*) \(contains (.*)\)$", line).captures
        String.(split(ingredients)), String.(split(allergens, ", "))
    end

    all_ingredients, all_allergens = Set{String}(), Set{String}()
    for (ingredients, allergens) in data
        all_ingredients = all_ingredients ∪ Set(ingredients)
        all_allergens = all_allergens ∪ Set(allergens)
    end
    all_ingredients, all_allergens = collect(all_ingredients), collect(all_allergens)

    d = Dict()
    for (ingredients, allergens) in data, allergen in allergens
        allergen ∉ keys(d) && ( d[allergen] = Set(ingredients) )
        d[allergen] = d[allergen] ∩ Set(ingredients)
    end

    MAX_NODES = length(all_ingredients) + length(all_allergens) + 2
    g = SimpleDiGraph(MAX_NODES)
    for i in all_ingredients
        i = 1 + findfirst(==(i), all_ingredients)
        add_edge!(g, 1, i)
    end
    for a in all_allergens
        a = length(all_ingredients) + 1 + findfirst(==(a), all_allergens)
        add_edge!(g, a, MAX_NODES)
    end
    for (allergen, ingredients) in d, ingredient in ingredients
        i = 1 + findfirst(==(ingredient), all_ingredients)
        a = 1 + length(all_ingredients) + findfirst(==(allergen), all_allergens)
        add_edge!(g, i, a)
    end

    graphplot(g,
        names = 1:MAX_NODES,
        x = vcat([[1]; [2 for _ in 1:length(all_ingredients)]; [3 for _ in 1:length(all_allergens)]; [4]]),
        y = vcat(
                 [
                  [1];
                  [i - length(all_ingredients) ÷ 2 for i in 1:length(all_ingredients)];
                  [a - length(all_allergens) ÷ 2 for a in 1:length(all_allergens)];
                  [1]
                 ]
                ),
        markercolor = vcat([
                            [colorant"white"];
                            [colorant"blue" for _ in 1:length(all_ingredients)];
                            [colorant"green" for _ in 1:length(all_allergens)];
                            [colorant"white"]
                      ]),
        markersize = 1)

    _, F = maximum_flow(g, 1, MAX_NODES)

    no_allergen_ingredients = all_ingredients[[i - 1 for i in 1:MAX_NODES if count(==(0), F[i, :]) == MAX_NODES]]

    no_allergen_ingredients
    part1 = sum(map(data) do (ingredients, _)
        count(i ∈ ingredients for i in no_allergen_ingredients)
    end)

    @show part1

    graphplot(F,
        names = 1:MAX_NODES,
        x = vcat([[1]; [2 for _ in 1:length(all_ingredients)]; [3 for _ in 1:length(all_allergens)]; [4]]),
        y = vcat(
                 [
                  [1];
                  [i - length(all_ingredients) ÷ 2 for i in 1:length(all_ingredients)];
                  [a - length(all_allergens) ÷ 2 for a in 1:length(all_allergens)];
                  [1]
                 ]
                ),
        markercolor = vcat([
                            [colorant"white"];
                            [colorant"blue" for _ in 1:length(all_ingredients)];
                            [colorant"green" for _ in 1:length(all_allergens)];
                            [colorant"white"]
                      ]),
        markersize = 1)
end
```

Original test case problem:

![image](https://user-images.githubusercontent.com/1813121/102918626-79641880-4444-11eb-9591-27b733840ae7.png)

Solving maximum flow on the test case problem:

![image](https://user-images.githubusercontent.com/1813121/102918648-84b74400-4444-11eb-9e6b-8ba98d764b53.png)

Thanks to @Wikunia for helping me figure this out.
