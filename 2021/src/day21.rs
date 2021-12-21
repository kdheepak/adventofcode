use std::{
  cmp::Ordering,
  collections::{BinaryHeap, HashMap, HashSet, VecDeque},
  ops::Add,
};

use ansi_term::Style;
use itertools::Itertools;

use crate::problem::Problem;

#[derive(Default)]
pub struct Day21 {}

impl Day21 {
}

fn f(
  s: &mut HashMap<(usize, usize, usize, usize), (usize, usize)>,
  p1: usize,
  p2: usize,
  s1: usize,
  s2: usize,
) -> (usize, usize) {
  if s1 >= 21 {
    return (1, 0);
  }
  if s2 >= 21 {
    return (0, 1);
  }
  if s.contains_key(&(p1, p2, s1, s2)) {
    return s[&(p1, p2, s1, s2)];
  }
  let mut ans = (0, 0);
  for d1 in [1, 2, 3] {
    for d2 in [1, 2, 3] {
      for d3 in [1, 2, 3] {
        let t = (p1 + d1 + d2 + d3 - 1) % 10 + 1;
        let st = s1 + t;
        let (x, y) = f(s, p2, t, s2, st);
        ans.0 += y;
        ans.1 += x;
      }
    }
  }
  *s.entry((p1, p2, s1, s2)).or_default() = ans;
  ans
}

impl Problem for Day21 {
  fn part1(&self, input: &str) -> Option<String> {
    let (p1, p2) = input.split_once('\n').unwrap();
    let (mut p1, mut p2) = (
      p1.split_once(": ").unwrap().1.parse::<usize>().unwrap(),
      p2.split_once(": ").unwrap().1.parse::<usize>().unwrap(),
    );
    let (mut p1_score, mut p2_score) = (0, 0);
    let mut die = 1;
    dbg!(p1, p2);
    loop {
      p1 = (p1 + die + die + 1 + die + 2 - 1) % 10 + 1;
      die += 3;
      p1_score += p1;
      if p1_score >= 1000 {
        break;
      }
      p2 = (p2 + die + die + 1 + die + 2 - 1) % 10 + 1;
      die += 3;
      p2_score += p2;
      if p2_score >= 1000 {
        break;
      }
    }
    dbg!(p1_score, p2_score, die - 1);
    Some((std::cmp::min(p1_score, p2_score) * (die - 1)).to_string())
  }

  fn part2(&self, input: &str) -> Option<String> {
    let (p1, p2) = input.split_once('\n').unwrap();
    let (p1, p2) = (
      p1.split_once(": ").unwrap().1.parse::<usize>().unwrap(),
      p2.split_once(": ").unwrap().1.parse::<usize>().unwrap(),
    );
    let mut s = HashMap::new();
    let (s1, s2) = f(&mut s, p1, p2, 0, 0);
    Some(std::cmp::max(s1, s2).to_string())
  }
}

#[cfg(test)]
mod tests {
  use indoc::indoc;

  use super::*;
  use crate::get_input;

  #[test]
  fn test_day21_part1() {
    let prob = Day21 {};

    let input = indoc! {"Player 1 starting position: 4
    Player 2 starting position: 8"};
    assert_eq!(prob.part1(input), None);
  }

  #[test]
  fn test_day21_part2() {
    let prob = Day21 {};
    let input = indoc! {""};
    assert_eq!(prob.part2(input), None);
  }
}
