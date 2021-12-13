use std::collections::{HashMap, VecDeque};

use ansi_term::Style;
use itertools::Itertools;

use crate::problem::Problem;

#[derive(Default)]
pub struct Day13 {}

impl Day13 {
}

fn visualize(map: &[Vec<bool>], xmax: usize, ymax: usize) {
  for y in 0..ymax {
    for x in 0..xmax {
      if map[y][x] {
        print!("#")
      } else {
        print!(" ")
      }
    }
    println!()
  }
  println!()
}

fn fold(input: &str, part1: bool) -> (Vec<Vec<bool>>, usize, usize) {
  let (points, folds) = input.split_once("\n\n").unwrap();
  let lines = points
    .lines()
    .map(|line| line.split_once(',').unwrap())
    .map(|(x, y)| (x.parse().unwrap(), y.parse().unwrap()))
    .collect::<Vec<(usize, usize)>>();
  let mut xmax = lines.iter().map(|p| p.0).max().unwrap();
  let mut ymax = lines.iter().map(|p| p.1).max().unwrap();

  if xmax % 2 != 0 { xmax += 1 }
  if ymax % 2 != 0 { ymax += 1 }

  let mut map = vec![vec![false; xmax + 1]; ymax + 1];

  for (x, y) in lines { map[y][x] = true }

  for (i, fold) in folds.lines().enumerate() {
    if i == 1 && part1 { break; }
    let fold = fold.replace("fold along ", "");
    let (fold_type, axis) = fold.split_once("=").unwrap();
    let axis = axis.parse::<usize>().unwrap();

    match fold_type {
      "y" => {
        ymax = axis;
        for y in 1..(map.len() / 2 + 1) {
          for x in 0..map[0].len() {
            if map[axis + y][x] {
              map[axis - y][x] = map[axis + y][x];
              map[axis + y][x] = false;
            }
          }
        }
      },
      "x" => {
        xmax = axis;
        for x in 1..(map[0].len() / 2 + 1) {
          for y in 0..map.len() {
            if map[y][axis + x] {
              map[y][axis - x] = map[y][axis + x];
              map[y][axis + x] = false;
            }
          }
        }
      },
      _ => panic!("Unknown fold type"),
    }
  }

  (map, xmax, ymax)
}

impl Problem for Day13 {
  fn part1(&self, input: &str) -> Option<String> {
    let (map, _, _) = fold(input, true);
    let ans = map.iter().map(|row| row.iter().filter(|p| **p).count()).sum::<usize>();
    Some(ans.to_string())
  }

  fn part2(&self, input: &str) -> Option<String> {
    let (map, xmax, ymax) = fold(input, false);
    let mut ans = String::new();
    ans = format!("{}{}", ans, "\n");
    for row in map.iter().take(ymax) {
      for item in row.iter().take(xmax) {
        if *item {
          ans = format!("{}{}", ans, "#")
        } else {
          ans = format!("{}{}", ans, " ")
        }
      }
      ans = format!("{}{}", ans, "\n")
    }
    Some(ans)
  }
}

#[cfg(test)]
mod tests {
  use indoc::indoc;

  use super::*;

  #[test]
  fn test_day13_part1() {
    let prob = Day13 {};
    let input = indoc! {"6,10
  0,14
  9,10
  0,3
  10,4
  4,11
  6,0
  6,12
  4,1
  0,13
  10,12
  3,4
  3,0
  8,4
  1,10
  2,14
  8,10
  9,0

  fold along y=7
  fold along x=5"};
    assert_eq!(prob.part1(input), None);
    // assert_eq!(prob.part1(&crate::get_input(13)), Some("3497".to_string()));
  }

  #[test]
  fn test_day13_part2() {
    let prob = Day13 {};
    let input = indoc! {"6,10
  0,14
  9,10
  0,3
  10,4
  4,11
  6,0
  6,12
  4,1
  0,13
  10,12
  3,4
  3,0
  8,4
  1,10
  2,14
  8,10
  9,0

  fold along y=7
  fold along x=5"};
    assert_eq!(prob.part2(input), None);
    // assert_eq!(prob.part2(&crate::get_input(13)), Some("93686".to_string()));
  }
}
