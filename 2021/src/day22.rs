use std::{
  cmp::{max, min, Ordering},
  collections::{BinaryHeap, HashMap, HashSet, VecDeque},
  ops::Add,
};

use ansi_term::Style;
use itertools::Itertools;

use crate::problem::Problem;

#[derive(Default)]
pub struct Day22 {}

impl Day22 {
}
type Border = (i64, i64);
type Cube = (Border, Border, Border, bool);

fn volume(((x_min, x_max), (y_min, y_max), (z_min, z_max), _): Cube) -> i64 {
  (x_max - x_min + 1) * (y_max - y_min + 1) * (z_max - z_min + 1)
}

fn range((min1, max1): (i64, i64), (min2, max2): (i64, i64)) -> Option<(i64, i64)> {
  if max1 < min2 {
    return None;
  }
  if min1 > max2 {
    return None;
  }
  let _min = min(max(min1, min2), max2);
  let _max = min(max(max1, min2), max2);
  Some((_min, _max))
}

fn subcube(cube1: Cube, cube2: Cube) -> Option<Cube> {
  let xr = range(cube1.0, cube2.0)?;
  let yr = range(cube1.1, cube2.1)?;
  let zr = range(cube1.2, cube2.2)?;
  Some((xr, yr, zr, cube1.3))
}

fn corrected_volume(c: Cube, rest: &[Cube]) -> i64 {
  let mut v = volume(c);
  let subcubes = rest.iter().filter_map(|&c2| subcube(c2, c)).collect::<Vec<_>>();
  for i in 0..subcubes.len() {
    v -= corrected_volume(subcubes[i], &subcubes[i + 1..]);
  }
  v
}

fn total_volume(cubes: &[Cube]) -> i64 {
  let mut v = 0;
  for i in 0..cubes.len() {
    if cubes[i].3 {
      v += corrected_volume(cubes[i], &cubes[i + 1..]);
    }
  }
  v
}
impl Problem for Day22 {
  fn part1(&self, input: &str) -> Option<String> {
    let mut cube = HashMap::new();
    input.lines().for_each(|l| {
      // on x=-15..36,y=-36..8,z=-12..33
      let (status, coords) = l.split_once(' ').unwrap();
      let mut coords = coords.split(',');
      let status = match status {
        "on" => true,
        "off" => false,
        _ => unreachable!(),
      };
      let (x_min, x_max) = coords.next().unwrap().split_once("..").unwrap();
      let (y_min, y_max) = coords.next().unwrap().split_once("..").unwrap();
      let (z_min, z_max) = coords.next().unwrap().split_once("..").unwrap();
      let (x_min, x_max) = (x_min.split_once('=').unwrap().1.parse::<i64>().unwrap(), x_max.parse::<i64>().unwrap());
      let (y_min, y_max) = (y_min.split_once('=').unwrap().1.parse::<i64>().unwrap(), y_max.parse::<i64>().unwrap());
      let (z_min, z_max) = (z_min.split_once('=').unwrap().1.parse::<i64>().unwrap(), z_max.parse::<i64>().unwrap());
      if x_min >= -50 && y_min >= -50 && z_min >= -50 && x_max <= 50 && y_max <= 50 && z_max <= 50 {
        for x in x_min..=x_max {
          for y in y_min..=y_max {
            for z in z_min..=z_max {
              *cube.entry((x, y, z)).or_insert(false) = status;
            }
          }
        }
      }
    });
    Some(cube.values().filter(|v| **v).count().to_string())
  }

  fn part2(&self, input: &str) -> Option<String> {
    let cubes = input
      .lines()
      .map(|l| {
        // on x=-15..36,y=-36..8,z=-12..33
        let (status, coords) = l.split_once(' ').unwrap();
        let mut coords = coords.split(',');
        let status = match status {
          "on" => true,
          "off" => false,
          _ => unreachable!(),
        };
        let (x_min, x_max) = coords.next().unwrap().split_once("..").unwrap();
        let (y_min, y_max) = coords.next().unwrap().split_once("..").unwrap();
        let (z_min, z_max) = coords.next().unwrap().split_once("..").unwrap();
        let (x_min, x_max) = (x_min.split_once('=').unwrap().1.parse::<i64>().unwrap(), x_max.parse::<i64>().unwrap());
        let (y_min, y_max) = (y_min.split_once('=').unwrap().1.parse::<i64>().unwrap(), y_max.parse::<i64>().unwrap());
        let (z_min, z_max) = (z_min.split_once('=').unwrap().1.parse::<i64>().unwrap(), z_max.parse::<i64>().unwrap());
        ((x_min, x_max), (y_min, y_max), (z_min, z_max), status)
      })
      .collect::<Vec<_>>();
    Some(total_volume(&cubes).to_string())
  }
}

#[cfg(test)]
mod tests {
  use indoc::indoc;

  use super::*;
  use crate::get_input;

  #[test]
  fn test_day22_part1() {
    let prob = Day22 {};
    let input = indoc! {""};
    assert_eq!(prob.part1(input), None);
  }

  #[test]
  fn test_day22_part2() {
    let prob = Day22 {};
    let input = indoc! {""};
    assert_eq!(prob.part2(input), None);
  }
}
