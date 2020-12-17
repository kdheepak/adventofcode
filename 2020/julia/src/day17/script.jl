using DataStructures

readInput() = strip(read(joinpath(@__DIR__, "./input.txt"), String))

part1(data = readInput()) = f(strip(data))

part2(data = readInput()) = g(strip(data))

const NEIGHBORS1 = CartesianIndex[]

for i in (0, 1, -1), j in (0, 1, -1), k in (0, 1, -1)
    push!(NEIGHBORS1, CartesianIndex(i, j, k))
end

function f(data)
    data = permutedims(reduce(hcat, collect.(split(data, '\n'))))
    grid = zeros(Bool, size(data)...)
    for i in 1:length(data)
        grid[i] = data[i] == '#'
    end
    grid

    pocket = Dict{NTuple{3, Int64}, Bool}()

    for j in 1:size(grid, 2), i in 1:size(grid, 1)
        pocket[(i, j, 0)] = grid[i, j]
    end

    cycle = 1
    while true
        cycle > 6 && break
        seen = Set{NTuple{3, Int64}}()
        tmp = Dict{NTuple{3, Int64}, Bool}()
        for k in collect(keys(pocket)), n in NEIGHBORS1
            xk, yk, zk = k
            xn, yn, zn = n.I
            push!(seen, (xk + xn, yk + yn, zk + zn))
        end
        for K in seen
            tmp[K] = find_next_state1(pocket, K...)
        end
        for k in keys(tmp)
            pocket[k] = tmp[k]
        end
        cycle += 1
    end
    count(values(pocket))
end

function find_next_state1(pocket, x, y, z)
    counter = []
    for index in NEIGHBORS1
        xindex, yindex, zindex = index.I
        xindex == 0 && yindex == 0 && zindex == 0 && continue
        if haskey(pocket, (x + xindex, y + yindex, z + zindex))
            push!(counter, pocket[(x + xindex, y + yindex, z + zindex)] == 1)
        else
            push!(counter, false)
        end
    end
    if ( count(counter) == 2 || count(counter) == 3 ) && haskey(pocket, (x, y, z)) && pocket[x, y, z]
        return true
    elseif !haskey(pocket, (x, y, z)) && count(counter) == 3
        return true
    elseif haskey(pocket, (x, y, z)) && pocket[x, y, z] == false && count(counter) == 3
        return true
    else
        return false
    end
end

const NEIGHBORS2 = CartesianIndex[]

for i in (0, 1, -1), j in (0, 1, -1), k in (0, 1, -1), l in (0, 1, -1)
    push!(NEIGHBORS2, CartesianIndex(i, j, k, l))
end

function g(data)
    data = permutedims(reduce(hcat, collect.(split(data, '\n'))))
    grid = zeros(Bool, size(data)...)
    for i in 1:length(data)
        grid[i] = data[i] == '#'
    end
    grid

    pocket = Dict{NTuple{4, Int64}, Bool}()

    for j in 1:size(grid, 2), i in 1:size(grid, 1)
        pocket[(i, j, 0, 0)] = grid[i, j]
    end

    cycle = 1
    while true
        cycle == 2 && break
        seen = Set{NTuple{4, Int64}}()
        tmp = Dict{NTuple{4, Int64}, Bool}()
        for k in collect(keys(pocket)), n in NEIGHBORS2
            xk, yk, zk, ak = k
            xn, yn, zn, an = n.I
            push!(seen, (xk + xn, yk + yn, zk + zn, ak + an))
        end
        for K in seen
            tmp[K] = find_next_state2(pocket, K...)
        end
        for k in keys(tmp)
            pocket[k] = tmp[k]
        end
        cycle += 1
    end
    pocket
end

function find_next_state2(pocket, x, y, z, a)
    counter = []
    for index in NEIGHBORS2
        xindex, yindex, zindex, aindex = index.I
        xindex == 0 && yindex == 0 && zindex == 0 && aindex == 0 && continue
        if haskey(pocket, (x + xindex, y + yindex, z + zindex, a + aindex))
            push!(counter, pocket[(x + xindex, y + yindex, z + zindex, a + aindex)] == 1)
        else
            push!(counter, false)
        end
    end
    if ( count(counter) == 2 || count(counter) == 3 ) && haskey(pocket, (x, y, z)) && pocket[x, y, z]
        return true
    elseif !haskey(pocket, (x, y, z, a)) && count(counter) == 3
        return true
    elseif haskey(pocket, (x, y, z, a)) && pocket[x, y, z, a] == false && count(counter) == 3
        return true
    else
        return false
    end
end
