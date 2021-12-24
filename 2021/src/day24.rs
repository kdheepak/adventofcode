use std::{
  cmp::{max, min, Ordering},
  collections::{BinaryHeap, HashMap, HashSet, VecDeque},
  ops::Add,
};

use ansi_term::Style;
use itertools::Itertools;

use crate::problem::Problem;

#[derive(Default)]
pub struct Day24 {}

impl Day24 {
}

impl Problem for Day24 {
  fn part1(&self, input: &str) -> Option<String> {
    let (mut w, mut x, mut y, mut z) = (0, 0, 0, 0);
    let inp = 0;
    for line in input.lines() {
      let mut splits = line.split(' ');
      match splits.next().unwrap() {
        "inp" => {
          match splits.next().unwrap() {
            "w" => w = inp,
            "x" => x = inp,
            "y" => y = inp,
            "z" => z = inp,
            _ => unreachable!(),
          };
        },
        "add" => {
        },
        "mul" => {},
        "div" => {},
        "mod" => {},
        "eql" => {},
        _ => unreachable!(),
      }
    }
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
  fn test_day24_part1() {
    let prob = Day24 {};
    let input = indoc! {""};
    assert_eq!(prob.part1(input), None);
  }

  #[test]
  fn test_day24_part2() {
    let prob = Day24 {};
    let input = indoc! {""};
    assert_eq!(prob.part2(input), None);
  }
}
