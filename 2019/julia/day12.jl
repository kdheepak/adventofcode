data = read(joinpath(@__DIR__, "../data/day12.txt"), String)

tdata1 = """
<x=-1, y=0, z=2>
<x=2, y=-10, z=-7>
<x=4, y=-8, z=8>
<x=3, y=5, z=-1>
""" |> strip

tdata2 = """
<x=-8, y=-10, z=0>
<x=5, y=5, z=10>
<x=2, y=-7, z=3>
<x=9, y=-8, z=-3>
""" |> strip

function get_positions(data)
    data = split(strip(data), "\n")
    positions = [parse.(Int, p.captures) for p in match.(r"x=(-?\d+), y=(-?\d+), z=(-?\d+)", data)]
    return positions
end

calculate_velocity(p1, p2) = p1 < p2 ? 1 : p1 > p2 ? -1 : 0

function simulate_step(positions, velocities)
    t = zeros(Int, length(positions[1]))
    for i in 1:length(positions)
        for j in i+1:length(positions)
            t[1], t[2], t[3] = calculate_velocity.(positions[i], positions[j])
            velocities[i] += t
            velocities[j] -= t
        end
    end
    for k in 1:length(positions)
        positions[k] += velocities[k]
    end
end

function calculate_energy(data, steps)
    positions = get_positions(data)
    velocities = [zeros(Int, 3) for _ in positions]
    for _ in 1:steps
        simulate_step(positions, velocities)
    end
    pot = [sum(abs.(p)) for p in positions]
    kin = [sum(abs.(v)) for v in velocities]
    return sum(pot .* kin)
end

@assert calculate_energy(tdata1, 10) == 179
@assert calculate_energy(tdata2, 100) == 1940
@assert calculate_energy(data, 1000) == 5350

function cycle(d_position)
    d_velocity = zeros(Int, length(d_position))
    states = Dict()
    counter = 0
    while true
        for i in 1:length(d_position)
            for j in i+1:length(d_position)
                d = calculate_velocity(d_position[i], d_position[j])
                d_velocity[i] += d
                d_velocity[j] -= d
            end
        end
        for k in 1:length(d_position)
            d_position[k] += d_velocity[k]
        end
        state = hash(hcat(d_velocity..., d_position...))
        if state in keys(states)
            return counter - states[state]
        end
        states[state] = counter
        counter += 1
    end
    return counter
end

function find_cycle_of_universe(data)
    initial_positions = get_positions(data)
    x = cycle([p[1] for p in initial_positions])
    y = cycle([p[2] for p in initial_positions])
    z = cycle([p[3] for p in initial_positions])
    return lcm(x, y, z)
end

@assert find_cycle_of_universe(tdata1) == 2772
@assert find_cycle_of_universe(tdata2) == 4686774924
@assert find_cycle_of_universe(data) == 467034091553512
