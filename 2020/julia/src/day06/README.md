
# https://adventofcode.com/2020/day/1

**Learnings**

One liner:

```julia
p12(d) = [sum(q->length(f(Set.(q)...)),split.(split(d,"\n\n"))) for f in (∪,∩)]
```

- \cap and \cup for set union and intersection
- Use `mapreduce`
- Some functions like `sum` accept function as the first input
