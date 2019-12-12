module aoc # See https://github.com/gsoleilhac/aoc19.jl

using Dates, BenchmarkTools, DataFrames, REPL

export part1, part2

for day = 1:25
    ds = "day$(lpad(day, 2, "0"))"
    d = Symbol(ds)
    eval(:(
        module $d
            include($ds * "/" * $ds * ".jl")
        end
    ))
end

getmodule(day) = getproperty(@__MODULE__, Symbol("day$(lpad(day, 2, "0"))"))

part1(; day::Int = min(Dates.day(Dates.today()), 25)) = (m = getmodule(day); m.part1(m.readInput()))
part2(; day::Int = min(Dates.day(Dates.today()), 25)) = (m = getmodule(day); m.part2(m.readInput()))

function benchmark(day::Int = min(Dates.day(Dates.today()), 25))
    m = getmodule(day)
    input = m.readInput()
    t1 = @belapsed($m.part1($input))
    t2 = @belapsed($m.part2($input))
    return t1, t2
end

formatTime(t) = (1e9 * t) |> BenchmarkTools.prettytime

function benchmarkAll()
    df = DataFrame(part1 = String[], part2 = String[])
    for day = 1:25
        println("Running benchmark for day $day ...")
        t1, t2 = benchmark(day)
        push!(df, formatTime.((t1, t2)))
    end
    df
end

end # module
