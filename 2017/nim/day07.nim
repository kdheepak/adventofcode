import strutils
import tables
import sequtils
import sugar
import math
import sets

const tdata = """
pbga (66)
xhth (57)
ebii (61)
havc (66)
ktlj (57)
fwft (72) -> ktlj, cntj, xhth
qoyq (66)
padx (45) -> pbga, havc, qoyq
tknk (41) -> ugml, padx, fwft
jptl (61)
ugml (68) -> gyxo, ebii, jptl
gyxo (61)
cntj (57)
""".strip()

proc parse(data: string): (Table[string, seq[string]], Table[string, int]) =
    var towers = initTable[string, seq[string]]()
    var weights = initTable[string, int]()
    for line in data.splitLines():
        let info = line.split()
        if info.len == 2:
            towers[info[0]] = @[]
            weights[info[0]] = info[1].strip(chars = {'(', ')'}).parseInt
        else:
            let v = lc[v.strip(chars={','}) | (v <- info[3..<info.len]), string]
            towers[info[0]] = v
            weights[info[0]] = info[1].strip(chars = {'(', ')'}).parseInt
    return (towers, weights)

const data = readFile("./inputs/day07.txt").strip()

let (d, weights) = parse(data)

proc find_root(data: Table[string, seq[string]], key: string): string =
    for k, v in data:
        if key in v:
            return find_root(data, k)
    return key

let k = lc[k | (k<-d.keys()), string][0]

let root = find_root(d, k)
echo root

proc net_weights(data: Table[string, seq[string]], weights: Table[string, int], root: string): int =
    var ws : seq[int] = @[]
    var s = initSet[int]()

    for v in data[root]:
        let w = net_weights(data, weights, v)
        ws.add(w)
        s.incl(w)

    if s.len > 1:
        for i, v in data[root]:
            echo root, ": ", v, " - ", weights[v], ", ", ws[i]

    return weights[root] + sum(ws)


echo net_weights(d, weights, root)



