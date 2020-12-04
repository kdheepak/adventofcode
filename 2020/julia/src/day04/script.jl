readInput() = strip(read(joinpath(@__DIR__, "./input.txt"), String))

function part1(data = readInput())
    lines = split(data, "\n\n")
    counter = 0
    for line in lines
        values = split(line, ['\n', ' '])
        counter += issubset(Set(["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]), Set([x for (x,y) in split.(values, ':')]))
    end
    counter
end

function part2(data = readInput())
    lines = split(data, "\n\n")
    counter = 0
    for line in lines
        values = split(line, ['\n', ' '])
        if !issubset(Set(["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]), Set([x for (x,y) in split.(values, ':')]))
            continue
        end
        passport = Dict([String(x) => String(y) for (x,y) in split.(values, ':')])
        c1 = 1920 <= parse(Int, passport["byr"]) <= 2002
        c2 = 2010 <= parse(Int, passport["iyr"]) <= 2020
        c3 = 2020 <= parse(Int, passport["eyr"]) <= 2030
        c4 = endswith(passport["hgt"], "cm") || endswith(passport["hgt"], "in")
        c5 = startswith(passport["hcl"], "#") && ( all([isdigit(x) for x in strip(passport["hcl"], ['#'])]) || !all([isdigit(x) for x in strip(passport["hcl"], ['#'])]) )
        c6 = passport["ecl"] ∈ ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
        c7 = length(passport["pid"]) == 9 && all([isdigit(x) for x in passport["pid"]])

        if c1 && c2 && c3 && c4 && c5 && c6 && c7

            if occursin( "cm", passport["hgt"],)
                if !( 150 <= parse(Int, replace(passport["hgt"], "cm" => "")) <= 193 )
                    continue
                end
            end

            if occursin("in",  passport["hgt"])
                if !( 59 <= parse(Int, replace(passport["hgt"], "in" => "")) <= 76 )
                    continue
                end
            end

            counter += 1

        end

    end
    counter
end
