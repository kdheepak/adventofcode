readInput() = read(joinpath(@__DIR__, "./input.txt"), String)

part1(data=readInput()) = execute(instructions(split(strip(data), "\n")))
part2(data=readInput()) = render(instructions(split(strip(data), "\n")))

test_data1 = """
noop
addx 3
addx -5
""";

test_data2 = """
addx 15
addx -11
addx 6
addx -3
addx 5
addx -1
addx -8
addx 13
addx 4
noop
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx -35
addx 1
addx 24
addx -19
addx 1
addx 16
addx -11
noop
noop
addx 21
addx -15
noop
noop
addx -3
addx 9
addx 1
addx -3
addx 8
addx 1
addx 5
noop
noop
noop
noop
noop
addx -36
noop
addx 1
addx 7
noop
noop
noop
addx 2
addx 6
noop
noop
noop
noop
noop
addx 1
noop
noop
addx 7
addx 1
noop
addx -13
addx 13
addx 7
noop
addx 1
addx -33
noop
noop
noop
addx 2
noop
noop
noop
addx 8
noop
addx -1
addx 2
addx 1
noop
addx 17
addx -9
addx 1
addx 1
addx -3
addx 11
noop
noop
addx 1
noop
addx 1
noop
noop
addx -13
addx -19
addx 1
addx 3
addx 26
addx -30
addx 12
addx -1
addx 3
addx 1
noop
noop
noop
addx -9
addx 18
addx 1
addx 2
noop
noop
addx 9
noop
noop
noop
addx -1
addx 2
addx -37
addx 1
addx 3
noop
addx 15
addx -21
addx 22
addx -6
addx 1
noop
addx 2
addx 1
noop
addx -10
noop
noop
addx 20
addx 1
addx 2
addx 2
addx -6
addx -11
noop
noop
noop
""";

function instructions(data)
  data = map(strip, data)
  ins = Union{Nothing,Int}[nothing]
  for line in data
    if occursin(" ", line)
      push!(ins, nothing)
      push!(ins, parse(Int, last(split(line, " "))))
    else
      push!(ins, nothing)
    end
  end
  ins
end

function execute(ins)
  x = 1
  r = []
  for (c, i) in enumerate(ins)
    if i !== nothing
      x += i
    end
    if c ∈ [20, 60, 100, 140, 180, 220]
      push!(r, (c, x))
    end
    @assert -1 <= x <= 41 "value of $x"
  end
  sum((c * x) for (c, x) in r)
end

function render(ins)
  x = 1
  CRT = zeros(Bool, 40, 6)
  for (c, i) in enumerate(ins)
    if i !== nothing
      x += i
    end
    p = rem(c - 1, size(CRT, 1))
    if x - 1 <= p <= x + 1
      CRT[CartesianIndex(c)] = true
    end
  end
  for i in axes(CRT, 2)
    for j in axes(CRT, 1)
      print(if CRT[j, i]
        '#'
      else
        ' '
      end)
    end
    println()
  end
end