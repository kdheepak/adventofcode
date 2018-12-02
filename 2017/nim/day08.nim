import tables
import strutils

const tdata = """
b inc 5 if a > 1
a inc 1 if b < 5
c dec -10 if a >= 1
c inc -20 if c == 10
""".strip()

var registers: Table[string, int] = initTable[string, int]()

type
    Operation = enum
        Inc, Dec

proc process(data: string): int =
    var max_v = 0

    for line in data.splitLines():
        let info = line.split()
        let name = info[0]
        var operation = Inc
        if info[1] == "inc":
            operation = Inc
        elif info[1] == "dec":
            operation = Dec
        else:
            echo "error"
        let value = info[2].parseInt

        let v_in_reg = registers.getOrDefault(info[4])
        let val = info[6].parseInt
        var condition = false
        if info[5] == ">" and v_in_reg > val:
            condition = true
        elif info[5] == "<" and v_in_reg < val:
            condition = true
        elif info[5] == "<=" and v_in_reg <= val:
            condition = true
        elif info[5] == ">=" and v_in_reg >= val:
            condition = true
        elif info[5] == "!=" and v_in_reg != val:
            condition = true
        elif info[5] == "==" and v_in_reg == val:
            condition = true
        if not @[">", "<", "<=", ">=", "!=", "=="].contains(info[5]):
            echo "Error"

        if condition == true:
            if operation == Inc:
                registers[name] = registers.getOrDefault(name) + value
            if operation == Dec:
                registers[name] = registers.getOrDefault(name) - value

        for k, v in registers:
            max_v = max(max_v, v)

    echo max_v
    # echo registers

const data = readFile("./inputs/day08.txt").strip()

discard process(data)

var max_v = 0
for k, v in registers:
    max_v = max(max_v, v)

echo registers
echo max_v

