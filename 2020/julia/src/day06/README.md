
# https://adventofcode.com/2020/day/1

**Learnings**

One liners:

```julia
part1(data = readInput()) = sum(q -> length(∪(Set.(q)...)), split.(split(data, "\n\n"), '\n', keepempty=false))

part2(data = readInput()) = sum(q -> length(∩(Set.(q)...)), split.(split(data, "\n\n"), '\n', keepempty=false))
```

- \cap and \cup for set union and intersection
- Use `mapreduce`
- Some functions like `sum` accept function as the first input
