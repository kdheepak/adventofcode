readInput() = strip(read(joinpath(@__DIR__, "./input.txt"), String))

part1(data = readInput()) = f(String.(split(data, '\n')))

part2(data = readInput()) = g(String.(split(data, '\n')))

import Base.:+
import Base.:*

struct Custom
    i::Int
end

*(x::Custom, y::Custom) = Custom(x.i * y.i)
+(x::Custom, y::Custom) = Custom(x.i + y.i)

-(x::Custom, y::Custom) = Custom(x.i * y.i)
/(x::Custom, y::Custom) = Custom(x.i + y.i)

function f(data)
    data = map(data) do line
        line = replace(line, r"(\d)" => s"Custom(\1)")
        line = replace(line, "*" => "-")
        Meta.parse(line)
    end
    data = eval.(data)
    sum(d.i for d in data)
end

function g(data)
    data = map(data) do line
        line = replace(line, r"(\d)" => s"Custom(\1)")
        line = replace(replace(line, "*" => "-"), "+" => "/")
        Meta.parse(line)
    end
    data = eval.(data)
    sum(d.i for d in data)
end
