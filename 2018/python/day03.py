
with open("./inputs/day03.txt") as f:
    data = f.read()

# data = """#1 @ 1,3: 4x4
# #2 @ 3,1: 4x4
# #3 @ 5,5: 2x2"""

grid = {}

for l in data.strip().splitlines():
    id, _, coord, size = l.split()
    x, y = coord.replace(":", "").split(",")
    width, height = size.split("x")
    for i in range(int(x), int(x) + int(width)):
        for j in range(int(y), int(y) + int(height)):
            grid[(i, j)] = grid.get((i, j), 0) + 1


print(len([k for k, v in grid.items() if v>=2]))

for l in data.strip().splitlines():
    id, _, coord, size = l.split()
    x, y = coord.replace(":", "").split(",")
    width, height = size.split("x")
    for i in range(int(x), int(x) + int(width)):
        for j in range(int(y), int(y) + int(height)):
            if grid[(i, j)] == 1:
                no_overlap = True
            else:
                no_overlap = False
                break
        if no_overlap == False:
            break
    if no_overlap == True:
        print(id)

