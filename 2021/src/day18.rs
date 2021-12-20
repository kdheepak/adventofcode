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
      Self::Node(num)
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
      Self::Link {
        left: Box::new(Self::new(&input[1..split_point])),
        right: Box::new(Self::new(&input[(split_point + 1)..(input.len() - 1)])),
      }
    }
  }

  fn magnitude(&self) -> usize {
    match self {
      Self::Node(v) => *v as usize,
      Self::Link { left: l, right: r } => 3 * l.magnitude() + 2 * r.magnitude(),
    }
  }

  fn absorb(&mut self, from_left: bool, v: usize) {
    match self {
      Self::Node(prev) => *prev += v,
      Self::Link { left: l, right: r } => {
        match from_left {
          true => l.absorb(from_left, v),
          false => r.absorb(from_left, v),
        }
      },
    }
  }

  fn explode(&mut self, depth: usize) -> Option<(usize, usize)> {
    if let Self::Node(_) = self {
      None
    } else if let Self::Link { left: l, right: r } = self {
      if depth == 4 {
        let a = match **l {
          Self::Node(v) => v,
          _ => unreachable!(),
        };
        let b = match **r {
          Self::Node(v) => v,
          _ => unreachable!(),
        };
        *self = Self::Node(0);
        Some((a, b))
      } else {
        if let Some((a, b)) = l.explode(depth + 1) {
          r.absorb(true, b);
          return Some((a, 0));
        }
        if let Some((a, b)) = r.explode(depth + 1) {
          l.absorb(false, a);
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
      Self::Node(v) => {
        if *v >= 10 {
          *self = Self::Link {
            left: Box::new(Self::Node((*v as f32 / 2.0).floor() as usize)),
            right: Box::new(Self::Node((*v as f32 / 2.0).ceil() as usize)),
          };
          Some(())
        } else {
          None
        }
      },
      Self::Link { left, right } => {
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
}

fn add(x: &Pair, y: &Pair) -> Pair {
  let mut res = Pair::Link { left: Box::new(x.clone()), right: Box::new(y.clone()) };
  while res.explode(0).is_some() || res.split().is_some() {}
  res
}

fn solve_1(input: &[Pair]) -> Option<String> {
  let res = input.iter().skip(1).fold(input[0].clone(), |acc, nxt| add(&acc, nxt));
  Some(res.magnitude().to_string())
}

fn solve_2(input: &[Pair]) -> Option<String> {
  let limit = input.len() - 1;
  let res = (0..limit).permutations(2).fold(0, |acc, e| {
    let a_p_b = add(&input[e[0]], &input[e[1]]).magnitude();
    let b_p_a = add(&input[e[0]], &input[e[1]]).magnitude();
    std::cmp::max(acc, a_p_b.max(b_p_a))
  });
  Some(res.to_string())
}

impl Problem for Day18 {
  fn part1(&self, input: &str) -> Option<String> {
    let input = input.split('\n').map(Pair::new).collect::<Vec<Pair>>();
    solve_1(&input)
  }

  fn part2(&self, input: &str) -> Option<String> {
    let input = input.split('\n').map(Pair::new).collect::<Vec<Pair>>();
    solve_2(&input)
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
