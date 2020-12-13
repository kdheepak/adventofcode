readInput() = strip(read(joinpath(@__DIR__, "./input.txt"), String))

part1(data = readInput()) = f(strip(data))

part2(data = readInput()) = g(strip(data))

function f(data)
    time, schedules = split(data, '\n')
    time, schedules = parse(Int, time), parse.(Int, filter(!=("x"), split(schedules, ',')))
    times = []
    for s in schedules, i in 1:s
        mod(time + i, s) == 0 && push!(times, s => time + i)
    end
    b, t = first(sort!(times, by = x -> x.second))
    b * (t - time)
end

function g(data)
    _, schedules = split(data, '\n')
    schedules = map(split(schedules, ',')) do s
        s == "x" ? 0 : parse(Int, s)
    end
    schedules = [(i-1) => s for (i, s) in enumerate(schedules) if s != 0]
    time = 0
    _, previous_schedule = schedules[1]
    i = 2
    while true
        i > length(schedules) && break
        busid, schedule = schedules[i]
        if mod(time + busid, schedule) == 0
            previous_schedule = lcm(previous_schedule, schedule)
            i += 1
        else
            time += previous_schedule
        end
    end
    time
end
