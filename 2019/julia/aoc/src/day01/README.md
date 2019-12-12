# [--- Day 1: The Tyranny of the Rocket Equation ---](https://adventofcode.com/2019/day/1)

The puzzle input contains the mass of various modules.
Here is a snippet of the `input.txt`:

```
113481
140620
...
149274
```

We can read the input from a file as a `String` using the following `readInput` function.

```julia
readInput() = read(joinpath(@__DIR__, "./input.txt"), String)
```

Let's define a function to calculate the fuel requirements for a module given its mass.

```julia
fuel_requirements(mass) = round(mass / 3, RoundDown) - 2
```

The solution for part 1 is as simple as calculating the sum of each number in the input file.
We can strip the input string of leading and trailing whitespace,
then split the string on whitespace (new line characters),
and then convert each element in the array to an integer.

```julia
parse(Int, line) for line in split(strip(data))
```

In Julia, you can use `parse(Int, "42")` to get the integer `42`.
Julia also has a dot broadcasting syntax, which means we can do the same thing using the following:

```julia
parse.(Int, split(strip(data)))
```

Similarly, we can dot broadcast the `fuel_requirements` function that we defined earlier
on the above `Vector{Int}` output from `parse.(Int, input)`.

```julia
part1(data = readInput()) = sum(fuel_requirements.(parse.(Int, split(strip(data)))))
```

And, that's the solution for part 1!

For part 2, we need to calculate the fuel requirements for the fuel requirements for the various modules,
and the fuel_requirements for those fuel_requirements, and so on and so on.
This problem lends itself well to recursion.
Let's define a `total_fuel_requirements` function, that calls itself if the mass of the fuel needs to be
taken into consideration.

```julia
function total_fuel_requirements(mass)
    fuel = fuel_requirements(mass)
    return fuel > 0 ? fuel + total_fuel_requirements(fuel) : 0
end
```

It is possible to use explicit `if ... else ... end` blocks in Julia, like so:

```julia
if fuel > 0
    return fuel + total_fuel_requirements(fuel)
else
    return 0
end
```

However, using a ternary conditional operator can make it easier for you to express your idea,
and can make the code succinct and easier to read.

```julia
return fuel > 0 ? fuel + total_fuel_requirements(fuel) : 0
```

We can use the same broadcasting operation as before to calculate the total_fuel_requirements.

```julia
part2(data = readInput()) = sum(total_fuel_requirements.(parse.(Int, split(strip(data)))))
```

### Tests

```julia
@test fuel_requirements(12) == 2
@test fuel_requirements(14) == 2
@test fuel_requirements(1969) == 654
@test fuel_requirements(100756) == 33583
@test part1() == 3262358

@test total_fuel_requirements(14) == 2
@test total_fuel_requirements(1969) == 966
@test total_fuel_requirements(100756) == 50346
@test part2() == 4890696
```

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*
