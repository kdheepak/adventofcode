using DataStructures

readInput() = read(joinpath(@__DIR__, "./input.txt"), String)

struct Chemical
    name::String
    quantity::Int
end

function parseData(data = readInput())
    reaction_formula = Dict{String, Vector{Chemical}}()
    reaction_quantity = Dict{String, Int}()
    for line in split(strip(data), "\n")
        lhs, rhs = split(line, "=>")
        ingredients = Chemical[]
        for item in split(strip(lhs), ",")
            q, v = split(strip(item), " ")
            q = parse(Int, q)
            v = String(v)
            push!(ingredients, Chemical(v, q))
        end
        q, v = split(strip(rhs), " ")
        q = parse(Int, q)
        v = String(v)
        reaction_formula[v] = ingredients
        reaction_quantity[v] = q
    end
    need = DefaultDict{String, Int}(0)
    have = DefaultDict{String, Int}(0)
    return reaction_formula, reaction_quantity, need, have
end


function generate(reaction_formula, reaction_quantity, element, need, have)
    formula = reaction_formula[element]
    quantity = reaction_quantity[element]
    count = Int(ceil(max(0, need[element] - have[element]) / quantity))
    have[element] += count * quantity
    for e in formula
        need[e.name] += count * e.quantity
    end
    for e in formula
        e.name == "ORE" && continue
        generate(reaction_formula, reaction_quantity, e.name, need, have)
    end
end


function part1(data = readInput())
    reaction_formula, reaction_quantity, need, have = parseData(data)
    need["FUEL"] = 1
    generate(reaction_formula, reaction_quantity, "FUEL", need, have)
    return need["ORE"]
end

function part2(data = readInput())
    reaction_formula, reaction_quantity, need, have = parseData(data)
    need["FUEL"] = 1
    generate(reaction_formula, reaction_quantity, "FUEL", need, have)
    max_ore = 1000000000000
    min_fuel = max_ore ÷ need["ORE"]
    max_fuel = min_fuel * 1_000_000
    while min_fuel < max_fuel-1
        mid_fuel = (min_fuel + max_fuel) ÷ 2
        reaction_formula, reaction_quantity, need, have = parseData(data)
        need["FUEL"] = mid_fuel
        generate(reaction_formula, reaction_quantity, "FUEL", need, have)
        if need["ORE"] < max_ore
            min_fuel = mid_fuel
        else
            max_fuel = mid_fuel - 1
        end
    end
    return min_fuel
end

# ### Tests

using Test

function runtests()
    test_data1 = """
        10 ORE => 10 A
        1 ORE => 1 B
        7 A, 1 B => 1 C
        7 A, 1 C => 1 D
        7 A, 1 D => 1 E
        7 A, 1 E => 1 FUEL
        """

    test_data2 = """
        9 ORE => 2 A
        8 ORE => 3 B
        7 ORE => 5 C
        3 A, 4 B => 1 AB
        5 B, 7 C => 1 BC
        4 C, 1 A => 1 CA
        2 AB, 3 BC, 4 CA => 1 FUEL
        """

    test_data3 = """
        157 ORE => 5 NZVS
        165 ORE => 6 DCFZ
        44 XJWVT, 5 KHKGT, 1 QDVJ, 29 NZVS, 9 GPVTF, 48 HKGWZ => 1 FUEL
        12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ
        179 ORE => 7 PSHF
        177 ORE => 5 HKGWZ
        7 DCFZ, 7 PSHF => 2 XJWVT
        165 ORE => 2 GPVTF
        3 DCFZ, 7 NZVS, 5 HKGWZ, 10 PSHF => 8 KHKGT
        """

    test_data4 = """
        2 VPVL, 7 FWMGM, 2 CXFTF, 11 MNCFX => 1 STKFG
        17 NVRVD, 3 JNWZP => 8 VPVL
        53 STKFG, 6 MNCFX, 46 VJHF, 81 HVMC, 68 CXFTF, 25 GNMV => 1 FUEL
        22 VJHF, 37 MNCFX => 5 FWMGM
        139 ORE => 4 NVRVD
        144 ORE => 7 JNWZP
        5 MNCFX, 7 RFSQX, 2 FWMGM, 2 VPVL, 19 CXFTF => 3 HVMC
        5 VJHF, 7 MNCFX, 9 VPVL, 37 CXFTF => 6 GNMV
        145 ORE => 6 MNCFX
        1 NVRVD => 8 CXFTF
        1 VJHF, 6 MNCFX => 4 RFSQX
        176 ORE => 6 VJHF
        """

    test_data5 = """
        171 ORE => 8 CNZTR
        7 ZLQW, 3 BMBT, 9 XCVML, 26 XMNCP, 1 WPTQ, 2 MZWV, 1 RJRHP => 4 PLWSL
        114 ORE => 4 BHXH
        14 VRPVC => 6 BMBT
        6 BHXH, 18 KTJDG, 12 WPTQ, 7 PLWSL, 31 FHTLT, 37 ZDVW => 1 FUEL
        6 WPTQ, 2 BMBT, 8 ZLQW, 18 KTJDG, 1 XMNCP, 6 MZWV, 1 RJRHP => 6 FHTLT
        15 XDBXC, 2 LTCX, 1 VRPVC => 6 ZLQW
        13 WPTQ, 10 LTCX, 3 RJRHP, 14 XMNCP, 2 MZWV, 1 ZLQW => 1 ZDVW
        5 BMBT => 4 WPTQ
        189 ORE => 9 KTJDG
        1 MZWV, 17 XDBXC, 3 XCVML => 2 XMNCP
        12 VRPVC, 27 CNZTR => 2 XDBXC
        15 KTJDG, 12 BHXH => 5 XCVML
        3 BHXH, 2 VRPVC => 7 MZWV
        121 ORE => 7 VRPVC
        7 XCVML => 6 RJRHP
        5 BHXH, 4 VRPVC => 5 LTCX
        """

    @testset "Day 14: Part 1" begin

        @test part1(test_data1) == 31
        @test part1(test_data2) == 165
        @test part1(test_data3) == 13312
        @test part1(test_data4) == 180697
        @test part1(test_data5) == 2210736
        @test part1() == 399063

    end

    @testset "Day 14: Part 2" begin
        @test part2(test_data3) == 82892753
        @test part2(test_data4) == 5586022
        @test part2(test_data5) == 460664
        @test part2() == 4215653
    end

end
