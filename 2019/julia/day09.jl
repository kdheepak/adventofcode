data = read(joinpath(@__DIR__, "../data/day09.txt"), String)

include("vm.jl")

tdata = [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]

vm = VM(tdata, channel(Int[]))
run!(vm)
@assert outputs(vm.output) == [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]

tdata = [1102,34915192,34915192,7,4,7,99,0]
vm = VM(tdata, channel(Int[]))
run!(vm)
@assert length(digits(outputs(vm.output)[1])) == 16

tdata = [104,1125899906842624,99]
vm = VM(tdata, channel(Int[]))
run!(vm)
@assert outputs(vm.output) == [1125899906842624]


data = [parse(Int, x) for x in split(strip(data), ",")]

vm = VM(data, channel(Int[1]))
run!(vm)
@assert outputs(vm.output) == [3335138414]

vm = VM(data, channel(Int[2]))
run!(vm)
@assert outputs(vm.output) == [49122]
