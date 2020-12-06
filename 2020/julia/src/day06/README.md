
# https://adventofcode.com/2020/day/1

**Learnings**

One liners:

```julia

part1(d) = sum(q->length(∪(Set.(q)...)),split.(split(d,"\n\n")))
part2(d) = sum(q->length(∩(Set.(q)...)),split.(split(d,"\n\n")))
```

- \cap and \cup for set union and intersection
- Use `mapreduce`
- Some functions like `sum` accept function as the first input
