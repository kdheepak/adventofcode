
const data1 = "{}" # score of 1.
const data2 = "{{{}}}" # score of 1 + 2 + 3 = 6.
const data3 = "{{},{}}" # score of 1 + 2 + 2 = 5.
const data4 = "{{{},{},{{}}}}" # score of 1 + 2 + 3 + 3 + 3 + 4 = 16.
const data5 = "{<a>,<a>,<a>,<a>}" # score of 1.
const data6 = "{{<ab>},{<ab>},{<ab>},{<ab>}}" # score of 1 + 2 + 2 + 2 + 2 = 9.
const data7 = "{{<!!>},{<!!>},{<!!>},{<!!>}}" # score of 1 + 2 + 2 + 2 + 2 = 9.
const data8 = "{{<a!>},{<a!>},{<a!>},{<ab>}}" # score of 1 + 2 = 3.


proc calculate_score(stream: string): int =

    var IgnoreChar: bool
    var InGarbage: bool

    var blockStartCounter: int
    var blockEndCounter: int

    var score: int
    var record_score: int
    var garbage_counter: int

    for c in stream:

        if IgnoreChar == true:
            IgnoreChar = false
            continue

        if InGarbage and c == '!':
            IgnoreChar = true
            continue
        elif not InGarbage and c == '<':
            InGarbage = true
            continue
        elif c == '>':
            InGarbage = false
            continue

        if not InGarbage and c == '{':
            score += 1

        elif not InGarbage and c == '}':
            record_score = record_score + score
            score -= 1

        if InGarbage:
            garbage_counter += 1

        if c == ',':
            discard

    echo "Garbage: ", garbage_counter
    return record_score

echo "data1: ", calculate_score(data1)
echo "data2: ", calculate_score(data2)
echo "data3: ", calculate_score(data3)
echo "data4: ", calculate_score(data4)
echo "data5: ", calculate_score(data5)
echo "data6: ", calculate_score(data6)
echo "data7: ", calculate_score(data7)
echo "data8: ", calculate_score(data8)

echo "Test Garbage: ", calculate_score("<>")
echo "Test Garbage: ", calculate_score("<random characters>")
echo "Test Garbage: ", calculate_score("<<<<>")

const data = readFile("./inputs/day09.txt")

echo "Solution: ", calculate_score(data)
