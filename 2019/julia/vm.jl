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
    input::Int
    output::Union{Nothing, Int}
end

VM(code, input = 1) = VM(OffsetVector(code, -1), 0, false, input, nothing)

function set_param(vm::VM, offset, value)
    vm.code[vm.code[vm.pointer + offset]] = value
end

function get_param(vm::VM, offset, mode)
    # modes is one indexed vector of the mode for each parameter
    # intcode is zero indexed
    return if mode == 1 # immediate
        vm.code[vm.pointer+offset]
    elseif mode == 0 # position
        vm.code[vm.code[vm.pointer+offset]]
    else
        error("Unknown mode")
    end
end

function run(vm::VM)
    while !vm.halted
        opcode = vm.code[vm.pointer]
        op = opcode % 100
        modes = digits(opcode ÷ 100)
        while length(modes) < 3
            push!(modes, 0)
        end
        evaluate!(vm, op, modes)
    end
    return vm.output
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
    set_param(vm, 1, vm.input)
    incr(vm, 2)
end
evaluate!(vm::VM, op::Val{Input}, _) = evaluate!(vm, op)

function evaluate!(vm::VM, op::Val{Output}, modes)
    p1 = get_param(vm, 1, modes[1])
    vm.output = p1
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

evaluate!(vm::VM, op::Val{Halt}, _) = evaluate!(vm, op)
function evaluate!(vm::VM, op::Val{Halt})
    vm.halted = true
end
