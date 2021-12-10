use std::collections::HashMap;

use itertools::Itertools;

use crate::problem::Problem;

#[derive(Default)]
pub struct Day10 {}

impl Day10 {
}

fn matches(c1: char, c2: char) -> bool {
  c1 == '(' && c2 == ')' || c1 == '[' && c2 == ']' || c1 == '<' && c2 == '>' || c1 == '{' && c2 == '}'
}

fn get_syntax_error_score(line: &str) -> usize {
  let mut stack = vec![];
  for char in line.chars() {
    if "([<{".contains(char) {
      stack.push(char);
    } else if matches(*stack.last().unwrap(), char) {
      stack.pop();
    } else {
      return match char {
        ')' => 3,
        ']' => 57,
        '}' => 1197,
        '>' => 25137,
        _ => panic!("Unexpected char"),
      };
    }
  }
  0
}

fn complete_syntax(line: &str) -> usize {
  let mut stack = vec![];
  for char in line.chars() {
    if "([<{".contains(char) {
      stack.push(char);
    } else if matches(*stack.last().unwrap(), char) {
      stack.pop();
    }
  }
  let mut score = 0;
  for char in stack.iter().rev() {
    score *= 5;
    score += match char {
      '(' => 1,
      '[' => 2,
      '{' => 3,
      '<' => 4,
      _ => panic!("Unexpected char"),
    }
  }
  score
}

impl Problem for Day10 {
  fn part1(&self, input: &str) -> Option<String> {
    let ans = input.lines().map(get_syntax_error_score).sum::<usize>();
    Some(ans.to_string())
  }

  fn part2(&self, input: &str) -> Option<String> {
    let scores = input.lines().filter(|line| get_syntax_error_score(line) == 0).map(complete_syntax).sorted().collect::<Vec<usize>>();
    Some(scores[scores.len() / 2].to_string())
  }
}

#[cfg(test)]
mod tests {
  use indoc::indoc;

  use super::*;

  #[test]
  fn test_day10_part1() {
    let prob = Day10 {};
    let input = indoc! {"[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]"};
    assert_eq!(prob.part1(input), Some("26397".to_string()));
    assert_eq!(prob.part1(&crate::get_input(10)), Some("271245".to_string()));
  }

  #[test]
  fn test_day10_part2() {
    let prob = Day10 {};
    let input = indoc! {"[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]"};
    assert_eq!(prob.part2(input), Some("288957".to_string()));
    assert_eq!(prob.part2(&crate::get_input(10)), Some("1685293086".to_string()));
  }
}
