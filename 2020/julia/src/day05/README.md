# Day 5 - https://adventofcode.com/2020/day/5

**Learnings**

- Use `parse(Int, s, base=2)` to parse binary data.

```julia
seatid(s) = parse(Int, map(c -> c ∈ ('R', 'B') ? '1' : '0', s), base = 2)
```

- Alternatively, use bitshifting

```julia
seatid(s) = reduce((x, y) -> (x << 1) | ((y == 'R') | (y == 'B')), s; init = 0)
```

- Use `mapreduce`

println("Part 1: ", mapreduce(seatid, max, eachline("input.txt")))
