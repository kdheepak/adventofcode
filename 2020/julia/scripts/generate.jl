for d in 2:25
    dstr = "day$(lpad(d, 2, "0"))"
    mkdir(joinpath("src", dstr))
    open(joinpath("src", dstr, "script.jl"), "w") do f
        write(f, """
readInput() = read(joinpath(@__DIR__, "./input.txt"), String)

part1(data = readInput()) = nothing

part2(data = readInput()) = nothing
""")
    end
    open(joinpath("src", dstr, "input.txt"), "w") do f
        write(f, "")
    end
end
