using Test

readInput() = read(joinpath(@__DIR__, "./input.txt"), String)

get_positions(data) = [parse.(Int, p.captures) for p in match.(r"x=(-?\d+), y=(-?\d+), z=(-?\d+)", split(strip(data), "\n"))]
calculate_velocity(p1, p2) = sign(p2 - p1)

function tick(positions, velocities)
    for i in 1:length(positions), j in i+1:length(positions)
        v = calculate_velocity.(positions[i], positions[j])
        velocities[i] += v
        velocities[j] -= v
    end
    positions .+= velocities
end

function calculate_energy(data, steps)
    positions = get_positions(data)
    velocities = [zeros(Int, 3) for _ in positions]
    for _ in 1:steps
        tick(positions, velocities)
    end
    pot = [sum(abs.(p)) for p in positions]
    kin = [sum(abs.(v)) for v in velocities]
    return sum(pot .* kin)
end

part1(data = readInput()) = calculate_energy(data, 1000)

function find_cycle(d_position)
    d_velocity = zeros(Int, length(d_position))
    states = Set{UInt64}()
    counter = 0
    while true
        state = hash(hcat(d_position..., d_velocity...))
        state ∈ states ? break : push!(states, state)
        counter += 1
        tick(d_position, d_velocity)
    end
    return counter
end

function find_cycle_of_universe(data)
    initial_positions = get_positions(data)
    x = find_cycle([p[1] for p in initial_positions])
    y = find_cycle([p[2] for p in initial_positions])
    z = find_cycle([p[3] for p in initial_positions])
    return lcm(x, y, z)
end

part2(data = readInput()) = find_cycle_of_universe(data)

function runtests()
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

    @testset "Day 12: Part 1" begin
        @test calculate_energy(tdata1, 10) == 179
        @test calculate_energy(tdata2, 100) == 1940
        @test part1() == 5350
    end;
    @testset "Day 12: Part 2" begin
        @test find_cycle_of_universe(tdata1) == 2772
        @test find_cycle_of_universe(tdata2) == 4686774924
        @test part2() == 467034091553512
    end
end
