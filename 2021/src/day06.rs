use serde_scan::scan;

use crate::problem::Problem;

#[derive(Default)]
pub struct Day06 {}

impl Day06 {
}

impl Problem for Day06 {
  fn part1(&self, input: &str) -> Option<String> {
    None
  }

  fn part2(&self, input: &str) -> Option<String> {
    None
  }
}

#[cfg(test)]
mod tests {
  use indoc::indoc;

  use super::*;

  #[test]
  fn test_day06_part1() {
    let prob = Day06 {};
    let input = indoc! {"
    "};
    assert_eq!(prob.part1(input), None);

    assert_eq!(prob.part1(&crate::get_input(5)), None);
  }

  #[test]
  fn test_day06_part2() {
    let prob = Day06 {};
    let input = indoc! {"
    "};
    assert_eq!(prob.part2(input), None);

    assert_eq!(prob.part2(&crate::get_input(5)), None);
  }
}
