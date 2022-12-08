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
    parent::Union{Dir, Nothing}
    total_size::Ref{Int}
end

Dir(path, parent=nothing) = Dir(path == "" ? "" : abspath(path), [], [], parent, 0)

function calc_size!(dir::Dir)
    x = 0
    for folder in dir.folders
        x += calc_size!(folder)
    end
    for file in dir.files
        x += file.size
    end
    dir.total_size[] = x
    x
end

function traverse(dir::Dir)
    x = []
    push!(x, (dir.path, dir.total_size[]))
    for folder in dir.folders
        push!(x, (dir.path, folder.total_size[]))
        for item in traverse(folder)
            push!(x, item)
        end
    end
    x
end

function part1(data = readInput())
    cur_dir = Dir("")
    root_dir = cur_dir
    for line in split(strip(data), "\n")
        if startswith(line, raw"$ cd /")
            cur_dir = root_dir
        elseif startswith(line, raw"$ cd ..")
            cur_dir = cur_dir.parent
        elseif startswith(line, raw"$ cd")
            _, path = split(line, raw"$ cd ")
            push!(cur_dir.folders, Dir(cur_dir.path * "/" * path, cur_dir))
            cur_dir = cur_dir.folders[end]
        elseif match(r"^\d+ .*", line) != nothing
            size, name = split(line, " ")
            push!(cur_dir.files, File(name, parse(Int, size)))
        end
    end
    calc_size!(root_dir)
    folders = traverse(root_dir)
    folders = unique(filter(f -> f[1] != "", folders))
    @show folders
    ([f[2] for f in filter(f -> f[2] <= 100000, folders)])
end
