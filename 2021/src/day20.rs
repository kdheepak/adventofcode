use std::{
  cmp::Ordering,
  collections::{BinaryHeap, HashMap, HashSet, VecDeque},
  ops::Add,
};

use ansi_term::Style;
use itertools::Itertools;

use crate::problem::Problem;

#[derive(Default)]
pub struct Day20 {}

impl Day20 {
}

fn display(image: &HashMap<(i64, i64), bool>) {
  let extent = 3;
  let x_min = image.keys().map(|(x, _)| x).min().unwrap() - extent;
  let x_max = image.keys().map(|(x, _)| x).max().unwrap() + extent;
  let y_min = image.keys().map(|(_, y)| y).min().unwrap() - extent;
  let y_max = image.keys().map(|(_, y)| y).max().unwrap() + extent;
  for x in x_min..=x_max {
    for y in y_min..=y_max {
      if image.contains_key(&(x, y)) && image[&(x, y)] {
        print!("#");
      } else {
        print!(".");
      }
    }
    println!();
  }
}

fn calculate_pixel(image: &HashMap<(i64, i64), bool>, xy: (i64, i64), algorithm: &[bool], default: bool) -> bool {
  let (x, y) = xy;
  let mut acc = 0;
  let mut i = 0;
  for row_d in [-1i8, 0, 1] {
    for col_d in [-1i8, 0, 1] {
      let b = *image.get(&(x + row_d as i64, y + col_d as i64)).unwrap_or(&default);
      acc |= (1 << (9 - i - 1)) * (b as usize);
      i += 1;
    }
  }
  algorithm[acc]
}

fn solve(input: &str, step: usize) -> Option<String> {
  let (algorithm, image) = input.split_once("\n\n").unwrap();
  let algorithm = algorithm.lines().join("").chars().map(|c| c == '#').collect::<Vec<bool>>();
  assert!(algorithm.len() == 512);
  let mut image = image
    .lines()
    .enumerate()
    .flat_map(|(x, l)| l.chars().enumerate().map(|(y, c)| ((x as i64, y as i64), c == '#')).collect::<Vec<_>>())
    .collect::<HashMap<(i64, i64), bool>>();

  // display(&image);
  let extent = 3;
  let mut default = false;
  for _ in 0..step {
    let x_min = image.keys().map(|(x, _)| x).min().unwrap() - extent;
    let x_max = image.keys().map(|(x, _)| x).max().unwrap() + extent;
    let y_min = image.keys().map(|(_, y)| y).min().unwrap() - extent;
    let y_max = image.keys().map(|(_, y)| y).max().unwrap() + extent;
    let mut output = image.clone();
    for y in y_min..=y_max {
      for x in x_min..=x_max {
        *output.entry((x, y)).or_default() = calculate_pixel(&image, (x, y), &algorithm, default);
      }
    }
    image = output;
    if algorithm[0] {
      default = !default;
    }
  }
  Some(image.values().filter(|v| **v).count().to_string())
}

impl Problem for Day20 {
  fn part1(&self, input: &str) -> Option<String> {
    solve(input, 2)
  }

  fn part2(&self, input: &str) -> Option<String> {
    solve(input, 50)
  }
}

#[cfg(test)]
mod tests {
  use indoc::indoc;

  use super::*;
  use crate::get_input;

  #[test]
  fn test_day20_part1() {
    let prob = Day20 {};

    let input = indoc! {"..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..##
#..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###
.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#.
.#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#.....
.#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#..
...####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.....
..##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

#..#.
#....
##..#
..#..
..###"};
    assert_eq!(prob.part1(input), Some("35".to_string()));
  }

  #[test]
  fn test_day20_part2() {
    let prob = Day20 {};
    let input = indoc! {"..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..##
#..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###
.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#.
.#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#.....
.#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#..
...####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.....
..##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

#..#.
#....
##..#
..#..
..###"};
    assert_eq!(prob.part2(&get_input(20)), Some("21149".to_string()));
  }
}
