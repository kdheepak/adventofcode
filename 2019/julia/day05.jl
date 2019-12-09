data = readlines(abspath(joinpath(@__DIR__, "../data/day05.txt")))

INTCODE = [parse(Int, s) for s in split(data[1], ',')]

include("vm.jl")

@assert outputs(run!(VM(copy(INTCODE), input = channel([1]))))[end] == 16225258

tdata = [3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8]
@assert outputs(run!(VM(tdata, input = channel([7]), maxsize = length(tdata))))[end] == 0
@assert outputs(run!(VM(tdata, input = channel([8]), maxsize = length(tdata))))[end] == 1

tdata = [3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8]
@assert outputs(run!(VM(tdata, input = channel([7]), maxsize = length(tdata))))[end] == 1
@assert outputs(run!(VM(tdata, input = channel([9]), maxsize = length(tdata))))[end] == 0

tdata = [3, 3, 1108, -1, 8, 3, 4, 3, 99]
@assert outputs(run!(VM(tdata, input = channel([7]), maxsize = length(tdata))))[end] == 0
@assert outputs(run!(VM(tdata, input = channel([8]), maxsize = length(tdata))))[end] == 1

tdata = [3, 3, 1107, -1, 8, 3, 4, 3, 99]
@assert outputs(run!(VM(tdata, input = channel([7]), maxsize = length(tdata))))[end] == 1
@assert outputs(run!(VM(tdata, input = channel([8]), maxsize = length(tdata))))[end] == 0

@assert outputs(run!(VM(copy(INTCODE), input = channel([5]), maxsize = length(INTCODE))))[end] == 2808771
