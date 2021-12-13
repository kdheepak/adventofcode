use std::collections::{HashMap, VecDeque};

use ansi_term::Style;
use itertools::Itertools;

use crate::problem::Problem;

#[derive(Default)]
pub struct Day13 {}

impl Day13 {
}

impl Problem for Day13 {
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
  fn test_day13_part1() {
    let prob = Day13 {};
    let input = indoc! {""};
    assert_eq!(prob.part1(input), None);
    // assert_eq!(prob.part1(&crate::get_input(13)), Some("3497".to_string()));
  }

  #[test]
  fn test_day13_part2() {
    let prob = Day13 {};
    let input = indoc! {""};
    assert_eq!(prob.part2(input), None);
    // assert_eq!(prob.part2(&crate::get_input(13)), Some("93686".to_string()));
  }
}
