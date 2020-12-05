# https://adventofcode.com/2020/day/2

**Learnings**

- Use `map` to return an array of results
- Use `keepempty=false` to discard empty strings when spliting
- Use `only` to return the only element of a collection. Errors if no element or multiple elements exist

```julia
function parseInput(file)
    data = readlines(joinpath(dirname(@__FILE__), file))
    map(data) do s
        s_lb, s_ub, s_char, pw = split(s, ['-', ':', ' '], keepempty=false)
        low, high = parse.(Int, [s_lb, s_ub])
        char = only(s_char)
        low,high,char,pw
    end
end

```

- Use `count` to write idiomatic code
- Use infix `xor` operator

```julia
function solve1(input)
    count(input) do low, high, char, pw
        low <= count(==(char), pw) <= high
    end
end

function solve2(input)
    count(input) do low, high, char, pw
        (pw[low] == char) ⊻ (pw[high] == char)
    end
end
```
