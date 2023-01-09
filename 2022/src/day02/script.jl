readInput() = read(joinpath(@__DIR__, "./input.txt"), String)

part1(data=readInput()) = total_score1(map(strip, split(strip(data), "\n")))
part2(data=readInput()) = total_score2(map(strip, split(strip(data), "\n")))

LOSE = 0
DRAW = 3
WIN = 6

mapping = Dict(
  "A" => :ROCK,
  "B" => :PAPER,
  "C" => :SCISSORS,
  "X" => :ROCK,
  "Y" => :PAPER,
  "Z" => :SCISSORS,
  ("A", "X") => :SCISSORS,
  ("A", "Y") => :ROCK,
  ("A", "Z") => :PAPER,
  ("B", "X") => :ROCK,
  ("B", "Y") => :PAPER,
  ("B", "Z") => :SCISSORS,
  ("C", "X") => :ROCK,
  ("C", "Y") => :SCISSORS,
  ("C", "Z") => :PAPER,
)

shape_score = Dict(
  "X" => 1,
  "Y" => 2,
  "Z" => 3,
)

function outcome(p1, p2)
  if p1 == p2
    DRAW
  elseif (p1 == :ROCK && p2 == :PAPER) || (p1 == :SCISSORS && p2 == :ROCK) || (p1 == :PAPER && p2 == :SCISSORS)
    WIN
  else
    LOSE
  end
end

function total_score1(data)
  sum(map(data) do line
    p1, p2 = split(line, " ")
    outcome(mapping[p1], mapping[p2]) + shape_score[p2]
  end)
end


function total_score2(data)
  sum(map(data) do line
    p1, p2 = split(line, " ")
    outcome(mapping[p1], mapping[(p1, p2)]) + shape_score[p2]
  end)
end