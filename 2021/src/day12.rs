use std::collections::HashMap;

use ansi_term::Style;
use itertools::Itertools;

use crate::problem::Problem;

#[derive(Default)]
pub struct Day12 {}

impl Day12 {
}

impl Problem for Day12 {
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
  fn test_day12_part1() {
    let prob = Day12 {};
    let input = indoc! {""};
    assert_eq!(prob.part1(input), None);
    // assert_eq!(prob.part1(&crate::get_input(12)), Some("1591".to_string()));
  }

  #[test]
  fn test_day12_part2() {
    let prob = Day12 {};
    let input = indoc! {""};
    assert_eq!(prob.part2(input), None);
    // assert_eq!(prob.part1(&crate::get_input(12)), Some("314".to_string()));
  }
}
