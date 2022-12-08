const test_input = raw"""
$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k
"""

readInput() = read(joinpath(@__DIR__, "./input.txt"), String)

struct File
    name::String
    size::Int
end

struct Dir
    path::String
    files::Vector{File}
    folders::Vector{Dir}
end

Dir(path) = Dir(path == "" ? "" : abspath(path), [], [])

function part1(data = readInput())
    cur_dir = Dir("")
    root_dir = cur_dir
    for line in split(strip(data), "\n")
        if startswith(line, raw"$ cd /")
            cur_dir = root_dir
        elseif startswith(line, raw"$ cd")
            _, path = split(line, raw"$ cd ")
            push!(cur_dir.folders, Dir(cur_dir.path * "/" * path))
            cur_dir = cur_dir.folders[end]
        end
    end
    root_dir
end
