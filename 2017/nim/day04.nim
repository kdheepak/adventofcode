import strutils
import sets
import algorithm
import sequtils

proc count(data: string): int =

    for l in data.splitLines():
        var s = initSet[string]()
        let passwords = l.split()
        for w in l.split():
            s.incl(w)
        if s.len == passwords.len:
            result = result + 1

proc toString(str: seq[char]): string =
  result = newStringOfCap(len(str))
  for ch in str:
    add(result, ch)

proc sortString(str: string): string =
    return sorted(toSeq(str.items), system.cmp).toString

proc countWithSort(data: string): int =

    for l in data.splitLines():
        var s = initSet[string]()
        let passwords = l.split()
        for w in l.split():
            s.incl(sortString(w))
        if s.len == passwords.len:
            result = result + 1

const data = readFile("./inputs/day03.txt").strip()

echo "Solution1: ", count(data)
echo "Solution2: ", countWithSort(data)
