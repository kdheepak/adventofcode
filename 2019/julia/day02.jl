using OffsetArrays

data = open(joinpath(@__DIR__, "./../data/day02.txt")) do f
    readlines(f)
end

INTCODE = [parse(Int, s) for s in split(data[1], ',')]

include("vm.jl")

vm = VM([1,9,10,3,2,3,11,0,99,30,40,50])
run!(vm)
@assert vm.code[0] == 3500

vm = VM([1,0,0,0,99])
run!(vm)
@assert vm.code[0] == 2

vm = VM([2,3,0,3,99])
run!(vm)
@assert vm.code[3] == 6

vm = VM([2,4,4,5,99,0])
run!(vm)
@assert vm.code[end] == 9801

vm = VM([1,1,1,4,99,5,6,0,99])
run!(vm)
@assert vm.code[0] == 30

# part 1
intcode = OffsetVector(copy(INTCODE), -1)
intcode[1] = 12
intcode[2] = 2
vm = VM(intcode)
run!(vm)
@assert vm.code[0] == 4570637

# part 2
for noun in 0:99
    for verb in 0:99
        intcode = OffsetVector(copy(INTCODE), -1)
        intcode[1] = noun
        intcode[2] = verb
        vm = VM(intcode)
        run!(vm)
        if vm.code[0] == 19690720
            @assert noun * 100 + verb == 5485
        end
    end
end
