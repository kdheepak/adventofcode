data = read(joinpath(@__DIR__, "../data/day09.txt"), String)

include("vm.jl")

tdata = [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]

vm = VM(tdata)
run!(vm)
@assert output(vm) == [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]

tdata = [1102,34915192,34915192,7,4,7,99,0]
vm = VM(tdata)
run!(vm)
@assert length(digits(output(vm)[1])) == 16

tdata = [104,1125899906842624,99]
vm = VM(tdata)
run!(vm)
@assert output(vm) == [1125899906842624]

vm = VM(data, input = channel(Int[1]))
run!(vm)
@assert output(vm) == [3335138414]

vm = VM(data, input = channel(Int[2]))
run!(vm)
@assert output(vm) == [49122]
