using OffsetArrays
using Combinatorics

data = read(abspath(joinpath(@__DIR__, "../data/day07.txt")), String)
data = [parse(Int, x) for x in split(data, ",")]

include("vm.jl")

function amplifiers_direct(data)
    maxoutput = 0

    for phase_setting in permutations([0, 1, 2, 3, 4])

        vmA = VM(copy(data), input = channel(Int[]), output = channel(Int[]), maxsize = length(data))
        vmB = VM(copy(data), input = vmA.output, output = channel(Int[]), maxsize = length(data))
        vmC = VM(copy(data), input = vmB.output, output = channel(Int[]), maxsize = length(data))
        vmD = VM(copy(data), input = vmC.output, output = channel(Int[]), maxsize = length(data))
        vmE = VM(copy(data), input = vmD.output, output = channel(Int[]), maxsize = length(data))

        put!(vmA.input, phase_setting[1])
        put!(vmB.input, phase_setting[2])
        put!(vmC.input, phase_setting[3])
        put!(vmD.input, phase_setting[4])
        put!(vmE.input, phase_setting[5])

        put!(vmA.input, 0)

        run!(vmA)
        run!(vmB)
        run!(vmC)
        run!(vmD)
        run!(vmE)

        maxoutput = max(maxoutput, take!(vmE.output))
    end

    return maxoutput
end

tdata = [3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0]
@assert amplifiers_direct(tdata) == 43210

tdata = [3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0]
@assert amplifiers_direct(tdata) == 54321

tdata = [3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0]
@assert amplifiers_direct(tdata) == 65210

# part 1
@assert amplifiers_direct(data) == 206580

############################################################################################

function amplifiers_feedback(data)
    maxoutput = 0

    for phase_setting in permutations([5, 6, 7, 8, 9])

        vmA = VM(copy(data), input = channel(Int[]), output = channel(Int[]), maxsize = length(data))
        vmB = VM(copy(data), input = vmA.output, output = channel(Int[]), maxsize = length(data))
        vmC = VM(copy(data), input = vmB.output, output = channel(Int[]), maxsize = length(data))
        vmD = VM(copy(data), input = vmC.output, output = channel(Int[]), maxsize = length(data))
        vmE = VM(copy(data), input = vmD.output, output = channel(Int[]), maxsize = length(data))
        vmA.input = vmE.output

        put!(vmA.input, phase_setting[1])
        put!(vmB.input, phase_setting[2])
        put!(vmC.input, phase_setting[3])
        put!(vmD.input, phase_setting[4])
        put!(vmE.input, phase_setting[5])

        put!(vmA.input, 0)

        @async run!(vmA)
        @async run!(vmB)
        @async run!(vmC)
        @async run!(vmD)
        @async run!(vmE)

        while vmE.halted != true
            sleep(0.0001)
        end
        maxoutput = max(maxoutput, take!(vmE.output))
    end

    return maxoutput
end

tdata = [3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5]
@assert amplifiers_feedback(tdata) == 139629729

tdata = [3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10]
@assert amplifiers_feedback(tdata) == 18216

# part 2
@assert amplifiers_feedback(data) == 2299406
