import collections
from dateutil import parser

times = collections.defaultdict(int)
minutes = collections.defaultdict(int)

with open("./inputs/day04.txt") as f:
    data = f.read().strip()

for line in sorted(data.splitlines()):
    time, event = line.split("]")
    time = parser.parse(time.strip("["))
    if "Guard" in event:
        guard = event.strip().split(" ")[1]
    elif "falls" in event:
        start_time = time
    elif "wakes" in event:
        end_time = time
        times[guard] = times[guard] + (end_time - start_time).seconds
        for t in range(start_time.minute, end_time.minute):
            minutes[guard, t] += 1

guard_name = (sorted(times.items(), key=lambda kv: kv[1]))[-1][0]
print(guard_name)
time = (sorted(times.items(), key=lambda kv: kv[1]))[-1][-1]
# print(time)

print(sorted(((t, v) for (guard, t), v in minutes.items() if guard == guard_name), key=lambda kv: kv[1])[-1][0])

print(sorted(minutes.items(), key=lambda kv: kv[1])[-1])
