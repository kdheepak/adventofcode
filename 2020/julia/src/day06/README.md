
# https://adventofcode.com/2020/day/1

**Learnings**

One liners:

```julia
part1(data) = sum(q->length(∪(Set.(q)...)),split.(split(data,"\n\n")))
part2(data) = sum(q->length(∩(Set.(q)...)),split.(split(data,"\n\n")))
```

- \cap and \cup for set union and intersection
- Use `mapreduce`
- Some functions like `sum` accept function as the first input
