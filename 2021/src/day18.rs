use std::{
  cmp::Ordering,
  collections::{BinaryHeap, HashMap, HashSet, VecDeque},
  ops::Add,
};

use ansi_term::Style;
use itertools::Itertools;

use crate::problem::Problem;

#[derive(Default)]
pub struct Day18 {}

impl Day18 {
}

#[derive(Debug, Clone, PartialEq)]
enum Pair {
  Node(usize),
  Link { left: Box<Pair>, right: Box<Pair> },
}

impl Pair {
  fn new(input: &str) -> Self {
    if let Ok(num) = input.parse() {
      Pair::Node(num)
    } else {
      let mut depth = 0;
      let mut split_point = 0;
      for (pos, c) in input.chars().enumerate() {
        match c {
          '[' => depth += 1,
          ']' => depth -= 1,
          ',' if depth == 1 => split_point = pos,
          _ => (),
        }
      }
      Pair::Link {
        left: Box::new(Self::new(&input[1..split_point])),
        right: Box::new(Self::new(&input[(split_point + 1)..(input.len() - 1)])),
      }
    }
  }

  fn reduce(&mut self) {
    while self.explode(0).is_some() || self.split().is_some() {}
  }

  fn absorb(&mut self, from_left: bool, v: usize) {
    match self {
      Pair::Node(prev) => *prev += v,
      Pair::Link { left: l, right: r } => {
        match from_left {
          true => l.absorb(from_left, v),
          false => r.absorb(from_left, v),
        }
      },
    }
  }

  fn explode(&mut self, depth: usize) -> Option<(usize, usize)> {
    if let Pair::Node(_) = self {
      None
    } else if let Pair::Link { left: l, right: r } = self {
      if depth == 4 {
        let a = match **l {
          Pair::Node(v) => v,
          _ => unreachable!(),
        };
        let b = match **l {
          Pair::Node(v) => v,
          _ => unreachable!(),
        };
        *self = Pair::Node(0);
        Some((a, b))
      } else {
        if let Some((a, b)) = l.explode(depth + 1) {
          r.absorb(true, b);
          return Some((a, 0));
        }
        if let Some((a, b)) = l.explode(depth + 1) {
          r.absorb(false, a);
          Some((0, b))
        } else {
          None
        }
      }
    } else {
      None
    }
  }

  fn split(&mut self) -> Option<()> {
    match self {
      Pair::Node(val) => {
        if *val >= 10 {
          *self = Pair::Link {
            left: Box::new(Pair::Node((*val as f32 / 2.0).floor() as usize)),
            right: Box::new(Pair::Node((*val as f32 / 2.0).ceil() as usize)),
          };
          Some(())
        } else {
          None
        }
      },
      Pair::Link { left, right } => {
        if left.split().is_some() {
          return Some(());
        }
        if right.split().is_some() {
          return Some(());
        }
        None
      },
    }
  }

  fn magnitude(&self) -> usize {
    match self {
      Pair::Node(val) => *val as usize,
      Pair::Link { left: l, right: r } => 3 * l.magnitude() + 2 * r.magnitude(),
    }
  }
}

fn add(x: &Pair, y: &Pair) -> Pair {
  let mut r = Pair::Link { left: Box::new(x.to_owned()), right: Box::new(x.to_owned()) };
  r.reduce();
  r
}

impl Problem for Day18 {
  fn part1(&self, input: &str) -> Option<String> {
    let pairs = input.lines().map(Pair::new).collect::<Vec<Pair>>();
    let mut acc = pairs[0].clone();
    for (i, p) in pairs.iter().enumerate().skip(1) {
      println!("{}", i);
      acc = add(&acc, p);
    }
    Some(acc.magnitude().to_string())
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
  fn test_day18_part1() {
    let prob = Day18 {};

    let input = indoc! {"[[[[1,3],[5,3]],[[1,3],[8,7]]],[[[4,9],[6,9]],[[8,2],[7,3]]]]"};
    assert_eq!(prob.part1(input), None);
  }

  #[test]
  fn test_day18_part2() {
    let prob = Day18 {};
    let input = indoc! {""};
    assert_eq!(prob.part2(input), None);
  }
}
