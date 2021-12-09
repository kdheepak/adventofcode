use std::collections::HashMap;

use itertools::Itertools;

use crate::problem::Problem;

#[derive(Default)]
pub struct Day10 {}

impl Day10 {
}

impl Problem for Day10 {
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
  fn test_day10_part1() {
    let prob = Day10 {};
    let input = indoc! {""};
    assert_eq!(prob.part1(input), None);
    assert_eq!(prob.part1(&crate::get_input(10)), None);
  }

  #[test]
  fn test_day10_part2() {
    let prob = Day10 {};
    let input = indoc! {""};
    assert_eq!(prob.part2(input), None);
    assert_eq!(prob.part2(&crate::get_input(10)), None);
  }
}
