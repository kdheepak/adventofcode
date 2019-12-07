data = readlines(abspath(joinpath(@__DIR__, "../data/day05.txt")))

INTCODE = [parse(Int, s) for s in split(data[1], ',')]

include("vm.jl")

@assert run(VM(copy(INTCODE), 1)) == 16225258

@assert run(VM([3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8], 7)) == 0
@assert run(VM([3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8], 8)) == 1

@assert run(VM([3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8], 7)) == 1
@assert run(VM([3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8], 9)) == 0

@assert run(VM([3, 3, 1108, -1, 8, 3, 4, 3, 99], 7)) == 0
@assert run(VM([3, 3, 1108, -1, 8, 3, 4, 3, 99], 8)) == 1

@assert run(VM([3, 3, 1107, -1, 8, 3, 4, 3, 99], 7)) == 1
@assert run(VM([3, 3, 1107, -1, 8, 3, 4, 3, 99], 8)) == 0

@assert run(VM(copy(INTCODE), 5)) == 2808771
