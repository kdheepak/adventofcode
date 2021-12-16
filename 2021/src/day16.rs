use std::{
  cmp::Ordering,
  collections::{BinaryHeap, HashMap, HashSet, VecDeque},
};

use ansi_term::Style;
use itertools::Itertools;

use crate::problem::Problem;

#[derive(Default)]
pub struct Day16 {}

impl Day16 {
}

impl Problem for Day16 {
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
  use crate::get_input;

  #[test]
  fn test_day16_part1() {
    let prob = Day16 {};
    let input = indoc! {""};
    assert_eq!(prob.part1(input), None);
    // assert_eq!(prob.part1(&get_input(16)), Some("423".to_string()));
  }

  #[test]
  fn test_day16_part2() {
    let prob = Day16 {};
    let input = indoc! {""};
    assert_eq!(prob.part2(input), None);
    // assert_eq!(prob.part2(&get_input(16)), Some("2778".to_string()));
  }
}
