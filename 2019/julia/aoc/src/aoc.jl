module aoc # See https://github.com/gsoleilhac/aoc19.jl

using Dates, BenchmarkTools, DataFrames, REPL, Literate

export part1, part2

for d in 1:25
    dstr = "day$(lpad(d, 2, "0"))"
    dsym = Symbol(dstr)
    eval(:(
        module $dsym
            include($dstr * "/" * $dstr * ".jl")
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

formatTime(t) = BenchmarkTools.prettytime(1e9 * t)

function benchmarkAll()
    df = DataFrame(part1 = String[], part2 = String[])
    for day = 1:25
        println("Running benchmark for day $day ...")
        t1, t2 = benchmark(day)
        push!(df, formatTime.((t1, t2)))
    end
    df
end

function generate_readme(;day::Int)
    dstr = "day$(lpad(day, 2, "0"))"
    Literate.markdown(
        "src/$dstr/$dstr.jl",
        "./src/$dstr/";
        config=Dict("name"=>"README"),
        documenter=false
    )
end

end # module
