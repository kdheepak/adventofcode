use std::{
  cmp::Ordering,
  collections::{BinaryHeap, HashMap, HashSet, VecDeque},
  ops::Add,
};

use ansi_term::Style;
use itertools::Itertools;

use crate::problem::Problem;

#[derive(Default)]
pub struct Day19 {}

impl Day19 {
}

fn rotate((x, y, z): (i64, i64, i64), rot: u8) -> (i64, i64, i64) {
  match rot {
    0 => (x, y, z),
    1 => (x, z, -y),
    2 => (x, -y, -z),
    3 => (x, -z, y),
    4 => (-x, y, -z),
    5 => (-x, z, y),
    6 => (-x, -y, z),
    7 => (-x, -z, -y),
    8 => (y, x, -z),
    9 => (y, z, x),
    10 => (y, -x, z),
    11 => (y, -z, -x),
    12 => (-y, x, z),
    13 => (-y, z, -x),
    14 => (-y, -x, -z),
    15 => (-y, -z, x),
    16 => (z, y, -x),
    17 => (z, -x, -y),
    18 => (z, -y, x),
    19 => (z, x, y),
    20 => (-z, x, -y),
    21 => (-z, y, x),
    22 => (-z, -x, y),
    23 => (-z, -y, -x),
    _ => unreachable!(),
  }
}

fn combine(total_scanners: &mut HashSet<(i64, i64, i64)>, scanner: &[(i64, i64, i64)]) -> Option<(i64, i64, i64)> {
  for rot in 0..24 {
    let rotated_scan = scanner.iter().map(|&v| rotate(v, rot)).collect::<Vec<_>>();
    let distances = total_scanners
      .iter()
      .cartesian_product(&rotated_scan)
      .map(|((x1, y1, z1), (x2, y2, z2))| (x1 - x2, y1 - y2, z1 - z2));
    for (dx, dy, dz) in distances {
      let translated = rotated_scan.iter().map(|(x, y, z)| (x + dx, y + dy, z + dz));
      if translated.clone().filter(|v| total_scanners.contains(v)).count() >= 12 {
        total_scanners.extend(translated);
        return Some((dx, dy, dz));
      }
    }
  }
  None
}

impl Problem for Day19 {
  fn part1(&self, input: &str) -> Option<String> {
    let mut scanners = input
      .split("\n\n")
      .map(|s| {
        s.lines()
          .skip(1)
          .map(|l| {
            let mut s = l.split(',');
            let x = s.next().unwrap().parse().unwrap();
            let y = s.next().unwrap().parse().unwrap();
            let z = s.next().unwrap().parse().unwrap();
            (x, y, z)
          })
          .collect_vec()
      })
      .collect_vec();
    let mut total_scanners = scanners.remove(0).into_iter().collect::<HashSet<_>>();
    while !scanners.is_empty() {
      for i in (0..scanners.len()).rev() {
        if let Some(d) = combine(&mut total_scanners, &scanners[i]) {
          scanners.remove(i);
        }
      }
    }
    Some(total_scanners.len().to_string())
  }

  fn part2(&self, input: &str) -> Option<String> {
    let mut scanners = input
      .split("\n\n")
      .map(|s| {
        s.lines()
          .skip(1)
          .map(|l| {
            let mut s = l.split(',');
            let x = s.next().unwrap().parse().unwrap();
            let y = s.next().unwrap().parse().unwrap();
            let z = s.next().unwrap().parse().unwrap();
            (x, y, z)
          })
          .collect_vec()
      })
      .collect_vec();
    let mut total_scanners = scanners.remove(0).into_iter().collect::<HashSet<_>>();
    let mut distances = vec![];
    while !scanners.is_empty() {
      for i in (0..scanners.len()).rev() {
        if let Some(d) = combine(&mut total_scanners, &scanners[i]) {
          scanners.swap_remove(i);
          distances.push(d);
        }
      }
    }
    Some(
      distances
        .iter()
        .tuple_combinations()
        .map(|((x1, y1, z1), (x2, y2, z2))| (x1 - x2).abs() + (y1 - y2).abs() + (z1 - z2).abs())
        .max()
        .unwrap()
        .to_string(),
    )
  }
}

#[cfg(test)]
mod tests {
  use indoc::indoc;

  use super::*;
  use crate::get_input;

  #[test]
  fn test_day19_part1() {
    let prob = Day19 {};

    let input = indoc! {""};
    assert_eq!(prob.part1(input), None);
  }

  #[test]
  fn test_day19_part2() {
    let prob = Day19 {};
    let input = indoc! {""};
    assert_eq!(prob.part2(input), None);
  }
}
