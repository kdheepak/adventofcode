use std::{
  cmp::Ordering,
  collections::{BinaryHeap, HashMap, HashSet, VecDeque},
};

use ansi_term::Style;
use itertools::Itertools;

use crate::problem::Problem;

#[derive(Default)]
pub struct Day17 {}

impl Day17 {
}

#[derive(Default)]
struct Probe {
  x: i64,
  y: i64,
  dx: i64,
  dy: i64,
  x_min: i64,
  x_max: i64,
  y_min: i64,
  y_max: i64,
  previous_x: i64,
  previous_y: i64,
  max_height: i64,
}

impl Probe {
  fn step(&mut self) {
    self.previous_x = self.x;
    self.previous_y = self.y;
    self.x += self.dx;
    self.y += self.dy;
    self.max_height = self.y.max(self.max_height);
    match self.dx.cmp(&0) {
      Ordering::Greater => self.dx -= 1,
      Ordering::Less => self.dx += 1,
      Ordering::Equal => (),
    }
    self.dy -= 1;
  }

  fn in_target(&mut self) -> bool {
    self.x_min <= self.x && self.x <= self.x_max && self.y_min <= self.y && self.y <= self.y_max
  }

  fn should_stop(&mut self) -> bool {
    self.y < self.y_min
  }
}

impl Problem for Day17 {
  fn part1(&self, input: &str) -> Option<String> {
    let t = input.replace("target area: ", "");
    let (x, y) = t.split_once(", ").unwrap();
    let x = x.replace("x=", "");
    let y = y.replace("y=", "");
    let (x_min, x_max) = x.split_once("..").unwrap();
    let (y_min, y_max) = y.split_once("..").unwrap();
    let (x_min, x_max, y_min, y_max) = (
      x_min.parse::<i64>().unwrap(),
      x_max.parse::<i64>().unwrap(),
      y_min.parse::<i64>().unwrap(),
      y_max.parse::<i64>().unwrap(),
    );
    dbg!(x_min, x_max, y_min, y_max);
    let (dx, dy) = (0, 0);
    let mut valid = vec![];

    for dx in 0..x_max + 1 {
      for dy in y_min..y_min.abs() {
        let mut p = Probe {
          x_min,
          x_max,
          y_min,
          y_max,
          x: 0,
          y: 0,
          dx,
          dy,
          previous_x: i64::MAX,
          previous_y: i64::MAX,
          max_height: i64::MIN,
        };
        while !(p.should_stop()) {
          p.step();
          // dbg!(p.x, p.y, p.dx, p.dy, p.x_min, p.x_max, p.y_min, p.y_max, p.previous_x, p.previous_y);
          if p.in_target() {
            valid.push(p.max_height);
          }
        }
      }
    }
    valid.sort_unstable();
    Some(valid.last().unwrap().to_string())
  }

  fn part2(&self, input: &str) -> Option<String> {
    let t = input.replace("target area: ", "");
    let (x, y) = t.split_once(", ").unwrap();
    let x = x.replace("x=", "");
    let y = y.replace("y=", "");
    let (x_min, x_max) = x.split_once("..").unwrap();
    let (y_min, y_max) = y.split_once("..").unwrap();
    let (x_min, x_max, y_min, y_max) = (
      x_min.parse::<i64>().unwrap(),
      x_max.parse::<i64>().unwrap(),
      y_min.parse::<i64>().unwrap(),
      y_max.parse::<i64>().unwrap(),
    );
    dbg!(x_min, x_max, y_min, y_max);
    let (dx, dy) = (0, 0);
    let mut valid = HashSet::new();

    for dx in 0..x_max + 1 {
      for dy in y_min..y_min.abs() {
        let mut p = Probe {
          x_min,
          x_max,
          y_min,
          y_max,
          x: 0,
          y: 0,
          dx,
          dy,
          previous_x: i64::MAX,
          previous_y: i64::MAX,
          max_height: i64::MIN,
        };
        while !(p.should_stop()) {
          p.step();
          // dbg!(p.x, p.y, p.dx, p.dy, p.x_min, p.x_max, p.y_min, p.y_max, p.previous_x, p.previous_y);
          if p.in_target() {
            valid.insert((dx, dy));
          }
        }
      }
    }
    Some(valid.len().to_string())
  }
}

#[cfg(test)]
mod tests {
  use indoc::indoc;

  use super::*;
  use crate::get_input;

  #[test]
  fn test_day17_part1() {
    let prob = Day17 {};
    let input = indoc! {"target area: x=20..30, y=-10..-5"};
    assert_eq!(prob.part1(input), None);
  }

  #[test]
  fn test_day17_part2() {
    let prob = Day17 {};
    let input = indoc! {""};
    assert_eq!(prob.part2(input), None);
  }
}
