use std::{
  cmp::{max, min, Ordering},
  collections::{BinaryHeap, HashMap, HashSet, VecDeque},
  ops::Add,
};

use ansi_term::Style;
use itertools::Itertools;

use crate::problem::Problem;

#[derive(Default)]
pub struct Day23 {}

impl Day23 {
}
impl Problem for Day23 {
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
  fn test_day23_part1() {
    let prob = Day23 {};
    let input = indoc! {""};
    assert_eq!(prob.part1(input), None);
  }

  #[test]
  fn test_day23_part2() {
    let prob = Day23 {};
    let input = indoc! {""};
    assert_eq!(prob.part2(input), None);
  }
}
