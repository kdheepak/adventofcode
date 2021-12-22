use std::{
  cmp::Ordering,
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
type Cube = (Border, Border, Border);

fn intersection(cube1: Cube, cube2: Cube) -> Option<Cube> {
  let ((x_min1, x_max1), (y_min1, y_max1), (z_min1, z_max1)) = cube1;
  let ((x_min2, x_max2), (y_min2, y_max2), (z_min2, z_max2)) = cube2;

  if x_min1 > x_max2 || x_min2 > x_max1 || y_min1 > y_max2 || y_min2 > y_max1 || z_min1 > z_max2 || z_min2 > z_max1 {
    return None;
  }
  Some((
    (std::cmp::max(x_min1, x_min2), std::cmp::min(x_max1, x_max2)),
    (std::cmp::max(y_min1, y_min2), std::cmp::min(y_max1, y_max2)),
    (std::cmp::max(y_min1, x_min2), std::cmp::min(y_max1, y_max2)),
  ))
}

fn difference(cube1: Cube, cube2: Cube) -> Vec<Cube> {
  if let Some(c) = intersection(cube1, cube2) {
    let mut subcubes = vec![];
    let ((x_min1, x_max1), (y_min1, y_max1), (z_min1, z_max1)) = cube1;
    let ((x_min2, x_max2), (y_min2, y_max2), (z_min2, z_max2)) = c;
    subcubes.push(((x_min1, x_max1), (y_min1, y_max1), (z_min1, z_max2 - 1)));
    subcubes.push(((x_min1, x_max1), (y_min1, y_max1), (z_min2 + 1, z_max1)));
    subcubes.push(((x_min1, x_max1), (y_min1, y_max2 - 1), (z_min2, z_max2)));
    subcubes.push(((x_min1, x_max1), (y_min2 + 1, y_max1), (z_min2, z_max2)));
    subcubes.push(((x_min1, x_max2 - 1), (y_min2, y_max2), (z_min2, z_max2)));
    subcubes.push(((x_min2 + 1, x_max1), (y_min2, y_max2), (z_min2, z_max2)));
    let mut v = vec![];
    for (x, y, z) in subcubes {
      if x.0 <= x.1 && y.0 <= y.1 && z.0 <= z.1 {
        v.push((x, y, z))
      }
    }
    v
  } else {
    vec![cube1]
  }
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
    let borders = input
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
        (x_min, x_max, y_min, y_max, z_min, z_max, status)
      })
      .collect::<Vec<_>>();

    let mut cubes = vec![];
    for border in borders {
      let (x_min, x_max, y_min, y_max, z_min, z_max, status) = border;
      let mut new_cubes = vec![];
      let this_cube = ((x_min, x_max), (y_min, y_max), (z_min, z_max));
      for cube in cubes {
        new_cubes.extend(difference(cube, this_cube))
      }
      if status {
        new_cubes.push(this_cube)
      }
      cubes = new_cubes
    }
    let mut s = 0;
    for cube in cubes {
      let ((x_min, x_max), (y_min, y_max), (z_min, z_max)) = cube;
      s += (x_max - x_min + 1) * (y_max - y_min + 1) * (z_max - z_min + 1)
    }
    Some(s.to_string())
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
