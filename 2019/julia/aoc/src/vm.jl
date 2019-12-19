using CEnum
using OffsetArrays

abstract type OpCode end

struct ADD <: OpCode end # Add
struct MUL <: OpCode end # Multiple
struct INP <: OpCode end # Input
struct OUT <: OpCode end # Output
struct JNZ <: OpCode end # Jump if true
struct JEZ <: OpCode end # Jump if false
struct OLT <: OpCode end # One if less than
struct OEQ <: OpCode end # One if equal
struct ROF <: OpCode end # Relative offset
struct END <: OpCode end # Halt

OPCODE_LOOKUP = Dict(
    01 => ADD(), # Add
    02 => MUL(), # Multiple
    03 => INP(), # Input
    04 => OUT(), # Output
    05 => JNZ(), # Jump if true
    06 => JEZ(), # Jump if false
    07 => OLT(), # One if less than
    08 => OEQ(), # One if equal
    09 => ROF(), # Relative offset
    99 => END(), # Halt
)

opcode(op) = OPCODE_LOOKUP[op % 100]
modes(op) = op ÷ 100 % 10, op ÷ 1000 % 10, op ÷ 10000 % 10

mutable struct VM
    code::OffsetVector{Int, Vector{Int}}
    pointer::Int
    halted::Bool
    input::Channel{Int}
    output::Channel{Int}
    relative_base_offset::Int
end

# for reference https://github.com/kleinschmidt/adventofcode2019/commit/e6e22841c621b0682284875ff2eed92e00b5e0dd
function channel(v)
    c = Channel{eltype(v)}(Inf)
    foreach(x -> put!(c, x), v)
    return c
end

function output(c::Channel)
    close(c)
    return [o for o in c]
end

input(c::Channel, x) = put!(c, x)

"""VM Interface function"""
VM(code; input = channel(Int[]), output = channel(Int[]), maxsize = 2^16) = VM(code, input, output, maxsize)

VM(code::String, input, output, maxsize) = VM([parse(Int, x) for x in split(strip(code), ",")], input, output, maxsize)
VM(code::Vector{T}, input, output, maxsize) where T <: Integer = VM(OffsetVector(copy(code), 0:(length(code) - 1)), input, output, maxsize)
function VM(code::OffsetVector{Int, Vector{Int}}, input, output, maxsize = 2^16)
    for _ in 1:(maxsize - length(code))
        push!(code, 0) # initialize memory larger than program to be zero
    end
    return VM(
        code, # OffsetVector
        0, # initial instruction pointer value
        false, # halt state
        input, # input channel
        output, # output channel
        0, # relative base offset
    )
end

function set_param(vm::VM, offset, mode, value)
    if mode == 2 # relative
        vm.code[vm.code[vm.pointer + offset] + vm.relative_base_offset] = value
    elseif mode == 0 # position
        vm.code[vm.code[vm.pointer + offset]] = value
    else
        error("Unknown mode: $mode")
    end
end

function get_param(vm::VM, offset, mode)
    # modes is one indexed vector of the mode for each parameter
    # intcode is zero indexed
    return if mode == 1 # immediate
        vm.code[vm.pointer + offset]
    elseif mode == 0 # position
        vm.code[vm.code[vm.pointer + offset]]
    elseif mode == 2 # relative
        vm.code[vm.code[vm.pointer + offset] + vm.relative_base_offset]
    else
        error("Unknown mode: $mode")
    end
end

function run!(vm::VM)
    m = zeros(Int, 3)
    while !vm.halted
        op = vm.code[vm.pointer]
        m[1], m[2], m[3] = modes(op)
        evaluate!(vm, opcode(op), m)
    end
    return vm
end

incr(vm::VM, offset::Int) = vm.pointer += offset
jmp(vm::VM, pointer::Int) = vm.pointer = pointer

output(vm::VM) = output(vm.output)
input(vm::VM, value) = input(vm.input, value)

function evaluate!(vm::VM, op::ADD, modes)
    p1 = get_param(vm, 1, modes[1])
    p2 = get_param(vm, 2, modes[2])
    set_param(vm, 3, modes[3], p1 + p2)
    incr(vm, 4)
end

function evaluate!(vm::VM, op::MUL, modes)
    p1 = get_param(vm, 1, modes[1])
    p2 = get_param(vm, 2, modes[2])
    set_param(vm, 3, modes[3], p1 * p2)
    incr(vm, 4)
end

function evaluate!(vm::VM, op::INP, modes)
    set_param(vm, 1, modes[1], take!(vm.input))
    incr(vm, 2)
end

function evaluate!(vm::VM, op::OUT, modes)
    p1 = get_param(vm, 1, modes[1])
    put!(vm.output, p1)
    incr(vm, 2)
end

function evaluate!(vm::VM, op::JNZ, modes)
    p1 = get_param(vm, 1, modes[1])
    p2 = get_param(vm, 2, modes[2])
    p1 != 0 ? jmp(vm, p2) : incr(vm, 3)
end

function evaluate!(vm::VM, op::JEZ, modes)
    p1 = get_param(vm, 1, modes[1])
    p2 = get_param(vm, 2, modes[2])
    p1 == 0 ? jmp(vm, p2) : incr(vm, 3)
end

function evaluate!(vm::VM, op::OLT, modes)
    p1 = get_param(vm, 1, modes[1])
    p2 = get_param(vm, 2, modes[2])
    set_param(vm, 3, modes[3], p1 < p2 ? 1 : 0)
    incr(vm, 4)
end

function evaluate!(vm::VM, op::OEQ, modes)
    p1 = get_param(vm, 1, modes[1])
    p2 = get_param(vm, 2, modes[2])
    set_param(vm, 3, modes[3], p1 == p2 ? 1 : 0)
    incr(vm, 4)
end

function evaluate!(vm::VM, op::ROF, modes)
    p1 = get_param(vm, 1, modes[1])
    vm.relative_base_offset += p1
    incr(vm, 2)
end

function evaluate!(vm::VM, op::END, modes)
    vm.halted = true
end

if length(ARGS) == 1 && ARGS[1] == "--test-intcode-vm"
    pop!(ARGS)
    @time include("day02.jl")
    @time include("day05.jl")
    @time include("day07.jl")
    @time include("day09.jl")
end
