use std::collections::HashMap;

use itertools::Itertools;

use crate::problem::Problem;

#[derive(Default)]
pub struct Day10 {}

impl Day10 {
}

fn handle_char(stack: &mut Vec<char>, c: char) -> Option<usize> {
  match c {
    '(' | '{' | '[' | '<' => stack.push(c),
    _ => {
      match (stack.pop(), c) {
        (Some('('), ')') => {},
        (Some('['), ']') => {},
        (Some('{'), '}') => {},
        (Some('<'), '>') => {},
        (_, ')') => return Some(3),
        (_, ']') => return Some(57),
        (_, '}') => return Some(1197),
        (_, '>') => return Some(25137),
        _ => unreachable!(),
      }
    },
  }
  None
}

fn get_syntax_error_score(line: &str) -> usize {
  let mut stack = vec![];
  line.chars().find_map(|c| handle_char(&mut stack, c)).unwrap_or(0)
}

fn complete_syntax(line: &str) -> usize {
  let mut stack = vec![];
  line.chars().find_map(|c| handle_char(&mut stack, c)).unwrap_or(0);
  stack.iter().rev().fold(0, |score, c| {
    match c {
      '(' => score * 5 + 1,
      '[' => score * 5 + 2,
      '{' => score * 5 + 3,
      '<' => score * 5 + 4,
      _ => panic!("Unexpected char"),
    }
  })
}

impl Problem for Day10 {
  fn part1(&self, input: &str) -> Option<String> {
    let ans = input.lines().map(get_syntax_error_score).sum::<usize>();
    Some(ans.to_string())
  }

  fn part2(&self, input: &str) -> Option<String> {
    let scores = input
      .lines()
      .filter(|line| get_syntax_error_score(line) == 0)
      .map(complete_syntax)
      .sorted()
      .collect::<Vec<usize>>();
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
