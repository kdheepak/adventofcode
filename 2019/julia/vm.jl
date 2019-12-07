using CEnum
using OffsetArrays

@cenum(
    OpCodes,
    Add = 1,
    Multiply = 2,
    Input = 3,
    Output = 4,
    JumpIfTrue = 5,
    JumpIfFalse = 6,
    LessThan = 7,
    Equals = 8,
    Halt = 99,
)

mutable struct VM
    code::OffsetVector{Int, Vector{Int}}
    pointer::Int
    halted::Bool
    input::Channel{Int}
    output::Channel{Int}
end

function channel(v)
    c = Channel{eltype(v)}(Inf)
    foreach(x -> put!(c, x), v)
    return c
end

VM(code, input = Int[1], output = Int[]) = VM(OffsetVector(code, 0:(length(code) - 1)), input, output)
VM(code::OffsetVector{Int, Vector{Int}}, input = channel(Int[1]), output = channel(Int[])) = VM(code, 0, false, input, output)

function set_param(vm::VM, offset, value)
    vm.code[vm.code[vm.pointer + offset]] = value
end

function get_param(vm::VM, offset, mode)
    # modes is one indexed vector of the mode for each parameter
    # intcode is zero indexed
    return if mode == 1 # immediate
        vm.code[vm.pointer + offset]
    elseif mode == 0 # position
        vm.code[vm.code[vm.pointer + offset]]
    else
        error("Unknown mode")
    end
end

function run!(vm::VM)
    while !vm.halted
        opcode = vm.code[vm.pointer]
        op = opcode % 100
        modes = digits(opcode ÷ 100)
        while length(modes) < 3
            push!(modes, 0)
        end
        evaluate!(vm, op, modes)
    end
end

incr(vm::VM, offset::Int) = vm.pointer += offset
jmp(vm::VM, pointer::Int) = vm.pointer = pointer

function evaluate!(vm::VM, op::Int, m::Vector{Int})
    if op ∈ instances(OpCodes)
        evaluate!(vm, Val(OpCodes(op)), m)
    else
        error("Unknown OpCode: $(vm.code[vm.pointer:vm.pointer+4])")
    end
end

function evaluate!(vm::VM, op::Val{Add}, modes)
    p1 = get_param(vm, 1, modes[1])
    p2 = get_param(vm, 2, modes[2])
    set_param(vm, 3, p1 + p2)
    incr(vm, 4)
end

function evaluate!(vm::VM, op::Val{Multiply}, modes)
    p1 = get_param(vm, 1, modes[1])
    p2 = get_param(vm, 2, modes[2])
    set_param(vm, 3, p1 * p2)
    incr(vm, 4)
end

function evaluate!(vm::VM, op::Val{Input})
    set_param(vm, 1, take!(vm.input))
    incr(vm, 2)
end
evaluate!(vm::VM, op::Val{Input}, _) = evaluate!(vm, op)

function evaluate!(vm::VM, op::Val{Output}, modes)
    p1 = get_param(vm, 1, modes[1])
    put!(vm.output, p1)
    incr(vm, 2)
end

function evaluate!(vm::VM, op::Val{JumpIfTrue}, modes)
    p1 = get_param(vm, 1, modes[1])
    p2 = get_param(vm, 2, modes[2])
    if p1 != 0
        jmp(vm, p2)
    else
        incr(vm, 3)
    end
end

function evaluate!(vm::VM, op::Val{JumpIfFalse}, modes)
    p1 = get_param(vm, 1, modes[1])
    p2 = get_param(vm, 2, modes[2])
    if p1 == 0
        jmp(vm, p2)
    else
        incr(vm, 3)
    end
end

function evaluate!(vm::VM, op::Val{LessThan}, modes)
    p1 = get_param(vm, 1, modes[1])
    p2 = get_param(vm, 2, modes[2])
    if p1 < p2
        set_param(vm, 3, 1)
    else
        set_param(vm, 3, 0)
    end
    incr(vm, 4)
end

function evaluate!(vm::VM, op::Val{Equals}, modes)
    p1 = get_param(vm, 1, modes[1])
    p2 = get_param(vm, 2, modes[2])
    if p1 == p2
        set_param(vm, 3, 1)
    else
        set_param(vm, 3, 0)
    end
    incr(vm, 4)
end

function evaluate!(vm::VM, op::Val{Halt})
    vm.halted = true
end
evaluate!(vm::VM, op::Val{Halt}, _) = evaluate!(vm, op)

outputs(vm::VM) = [o for o in vm.output]
