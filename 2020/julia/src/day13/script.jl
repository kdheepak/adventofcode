readInput() = strip(read(joinpath(@__DIR__, "./input.txt"), String))

part1(data = readInput()) = f(strip(data))

part2(data = readInput()) = g(strip(data))

function f(data)
    time, schedules = split(data, '\n')
    time = parse(Int, time)
    schedules = parse.(Int, filter(!=("x"), split(schedules, ',')))
    times = []
    for s in schedules
        for i in 0:s
            if mod(time + i, s) == 0
                push!(times, s => time + i)
            end
        end
    end
    sort!(times, by = x -> x.second)
    times[begin].first * (times[begin].second - time)
end

function g(data)
    _, schedules = split(data, '\n')
    schedules = map(split(schedules, ',')) do s
        s == "x" ? 0 : parse(Int, s)
    end
    schedules = [(i-1) => s for (i, s) in enumerate(schedules) if s != 0]
    time = 0
    previous_schedule = schedules[1].second
    index = 2
    @show previous_schedule
    while true
        if index > length(schedules)
            break
        end
        busid, schedule = schedules[index]
        @show busid, previous_schedule, schedule, time
        if mod(time + busid, schedule) == 0
            @show previous_schedule, schedule, lcm(previous_schedule, schedule)
            previous_schedule = lcm(previous_schedule, schedule)
            index += 1
        else
            time += previous_schedule
            @show time
        end
    end
    time
end
