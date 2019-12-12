# --- Day 1: The Tyranny of the Rocket Equation ---

We can read the input from a file
Input contains mass of various modules
`input.txt`:
```
113481
140620
...
149274
```

```julia
readInput() = strip(read(joinpath(@__DIR__, "./input.txt"), String))
```

First let's define a function to calculate the fuel requirements for a module given its mass.

```julia
fuel_requirements(mass) = round(mass / 3, RoundDown) - 2
```

The solution for part 1 is as taking the sum of the number in each line
We can strip the string of leading and trailing whitespace,
then split the string on whitespace (new line characters),
and then convert each element in the array to a integer

```julia
parse(Int, line) for line in split(strip(data))
```

In Julia, you can use `parse(Int, "42")` to get the integer `42`
Julia also supports a broadcasting operation, which means we can do the same thing using

```julia
parse.(Int, split(strip(data)))
```

Similarly, we can use the broadcasting operation of the Vector{Int} using the `fuel_requirements` function

```julia
part1(data = readInput()) = sum(fuel_requirements.(parse.(Int, split(strip(data)))))
```

That's the solution for part 1!
For part 2, we need to calculate the fuel requirements for the fuel requirements for the various modules
We can use recursion for this.

```julia
function total_fuel_requirements(mass)
    fuel = fuel_requirements(mass)
    return fuel > 0 ? fuel + total_fuel_requirements(fuel) : 0
end
```

And we can use the same broadcasting operator to calculate total_fuel_requirements

```julia
part2(data = readInput()) = sum(total_fuel_requirements.(parse.(Int, split(strip(data)))))
```

### Tests

```julia
function runtests()
    @testset "Day 01: Part 1" begin
        @test fuel_requirements(12) == 2
        @test fuel_requirements(14) == 2
        @test fuel_requirements(1969) == 654
        @test fuel_requirements(100756) == 33583
        @test part1() == 3262358
    end
    @testset "Day 01: Part 2" begin
        @test total_fuel_requirements(14) == 2
        @test total_fuel_requirements(1969) == 966
        @test total_fuel_requirements(100756) == 50346

        @test part2() == 4890696
    end
end
```

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*

