# https://adventofcode.com/2020/day/3

**Learnings**

- Use `reduce` with `hcat`/`vcat`
- Use `permutedims` to transpose data

```julia
readInput(input_file) = permutedims(reduce(hcat, collect.(readlines(input_file))))
```

- Use `mod1` for 1 based mod
- Use `cld` and `fld` for ceiling division and floor division
- Use `range` function with step and length keyword args
- Use `CartesianIndex` to index into arrays

```julia
function solve1(trees, slope)

    # Number of coordinates to be checked
    n = cld(size(trees, 1), slope.down)

    # Row- and column-coordinates to be checked
    rs = range(1, step=slope.down, length=n)
    cs = range(0, step=slope.right, length=n)

    # The problem says the tree pattern repeats to the right indefinitely.
    # Trick: we don't actually need to copy the pattern; instead,
    #        we can simply wrap the column-coordinates around.
    cs = map(x -> x % size(trees, 2) + 1, cs)

    idxs = CartesianIndex.(rs, cs)
    count(trees[idxs])

end
```
