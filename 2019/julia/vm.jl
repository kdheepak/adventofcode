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

struct Op{T}
    modes::Vector{Int}
end

function Op(opcode)
    op = OpCodes(opcode % 100)
    if op ∉ instances(OpCodes)
        error("Unknown OpCode: $(op)")
    end
    modes = digits(opcode ÷ 100)
    while length(modes) < 3
        push!(modes, 0)
    end
    return Op{op}(modes)
end


mutable struct VM
    code::OffsetVector{Int, Vector{Int}}
    pointer::Int
    halted::Bool
    input::Channel{Int}
    output::Channel{Int}
end

# for reference https://github.com/kleinschmidt/adventofcode2019/commit/e6e22841c621b0682284875ff2eed92e00b5e0dd
function channel(v)
    c = Channel{eltype(v)}(Inf)
    foreach(x -> put!(c, x), v)
    return c
end
function outputs(c::Channel)
    close(c)
    return [o for o in c]
end

VM(code, input = channel(Int[1]), output = channel(Int[])) = VM(OffsetVector(code, 0:(length(code) - 1)), input, output)
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
        evaluate!(vm, Op(opcode))
    end
    return vm.output
end

incr(vm::VM, offset::Int) = vm.pointer += offset
jmp(vm::VM, pointer::Int) = vm.pointer = pointer

function evaluate!(vm::VM, op::Op{Add})
    p1 = get_param(vm, 1, op.modes[1])
    p2 = get_param(vm, 2, op.modes[2])
    set_param(vm, 3, p1 + p2)
    incr(vm, 4)
end

function evaluate!(vm::VM, op::Op{Multiply})
    p1 = get_param(vm, 1, op.modes[1])
    p2 = get_param(vm, 2, op.modes[2])
    set_param(vm, 3, p1 * p2)
    incr(vm, 4)
end

function evaluate!(vm::VM, op::Op{Input})
    set_param(vm, 1, take!(vm.input))
    incr(vm, 2)
end

function evaluate!(vm::VM, op::Op{Output})
    p1 = get_param(vm, 1, op.modes[1])
    put!(vm.output, p1)
    incr(vm, 2)
end

function evaluate!(vm::VM, op::Op{JumpIfTrue})
    p1 = get_param(vm, 1, op.modes[1])
    p2 = get_param(vm, 2, op.modes[2])
    if p1 != 0
        jmp(vm, p2)
    else
        incr(vm, 3)
    end
end

function evaluate!(vm::VM, op::Op{JumpIfFalse})
    p1 = get_param(vm, 1, op.modes[1])
    p2 = get_param(vm, 2, op.modes[2])
    if p1 == 0
        jmp(vm, p2)
    else
        incr(vm, 3)
    end
end

function evaluate!(vm::VM, op::Op{LessThan})
    p1 = get_param(vm, 1, op.modes[1])
    p2 = get_param(vm, 2, op.modes[2])
    if p1 < p2
        set_param(vm, 3, 1)
    else
        set_param(vm, 3, 0)
    end
    incr(vm, 4)
end

function evaluate!(vm::VM, op::Op{Equals})
    p1 = get_param(vm, 1, op.modes[1])
    p2 = get_param(vm, 2, op.modes[2])
    if p1 == p2
        set_param(vm, 3, 1)
    else
        set_param(vm, 3, 0)
    end
    incr(vm, 4)
end

function evaluate!(vm::VM, op::Op{Halt})
    vm.halted = true
end
