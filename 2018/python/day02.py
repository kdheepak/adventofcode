with open("./inputs/day02.txt") as f:
    data = f.read()

from collections import Counter

twos = 0
threes = 0

for line in data.split():
    c = Counter(line)
    number_of_twos = len([_ for _, num in c.most_common() if num == 2])
    if number_of_twos > 0:
        twos += 1
    number_of_threes = len([_ for _, num in c.most_common() if num == 3])
    if number_of_threes > 0:
        threes += 1

print(twos * threes)

closest = []


import sys

for line1 in data.split():
    for line2 in data.split():
        found_diff = 0
        for c1, c2 in zip(line1, line2):
            s = ord(c1) - ord(c2)
            if s == 0:
                continue
            if s != 0:
                found_diff = found_diff + 1
        if found_diff == 1:
            for c1, c2 in zip(line1, line2):
                if c1 == c2:
                    print(c1, end="")
            print()
            sys.exit(0)

