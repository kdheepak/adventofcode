use crate::problem::Problem;

#[derive(Default)]
pub struct Day01 {}

impl Problem for Day01 {
  fn part1(&self, input: &str) -> Option<String> {
    let ans = input
      .split_whitespace()
      .map(|line| line.parse::<usize>().unwrap())
      .collect::<Vec<usize>>()
      .windows(2)
      .filter(|e| e[1] > e[0])
      .count();
    Some(ans.to_string())
  }

  fn part2(&self, input: &str) -> Option<String> {
    let ans = input
      .split_whitespace()
      .map(|line| line.parse::<usize>().unwrap())
      .collect::<Vec<usize>>()
      .windows(4)
      .filter(|e| e[3] > e[0])
      .count();
    Some(ans.to_string())
  }
}

#[cfg(test)]
mod tests {
  use indoc::indoc;

  use super::*;

  #[test]
  fn test_day01_part1() {
    let input = indoc! {"
      199
      200
      208
      210
      200
      207
      240
      269
      260
      263
    "};
    let prob = Day01 {};

    assert_eq!(prob.part1(input), Some("7".to_string()));

    assert_eq!(prob.part1(&crate::get_input(1)), Some("1121".to_string()));
  }

  #[test]
  fn test_day01_part2() {
    let input = indoc! {"
      199
      200
      208
      210
      200
      207
      240
      269
      260
      263
    "};
    let prob = Day01 {};

    assert_eq!(prob.part2(input), Some("5".to_string()));

    assert_eq!(prob.part2(&crate::get_input(1)), Some("1065".to_string()));
  }
}
