use std::{
  cmp::{max, min, Ordering},
  collections::{BinaryHeap, HashMap, HashSet, VecDeque},
  ops::Add,
};

use ansi_term::Style;
use itertools::Itertools;

use crate::problem::Problem;

#[derive(Default)]
pub struct Day25 {}

impl Day25 {
}

fn display(grid: &[Vec<char>]) {
  for x in 0..grid.len() {
    for y in 0..grid[0].len() {
      print!("{}", grid[x][y]);
    }
    println!();
  }
  println!();
}

impl Problem for Day25 {
  fn part1(&self, input: &str) -> Option<String> {
    let mut grid = input.lines().map(|l| l.chars().collect::<Vec<char>>()).collect::<Vec<_>>();

    let mut step = 0;
    let mut previous_grid = grid.clone();
    // println!("Initial state");
    // display(&grid);
    loop {
      let mut should_move = vec![];
      for x in 0..grid.len() {
        for y in 0..grid[0].len() {
          if grid[x][y] == '>' {
            let t = if y == grid[0].len() - 1 { 0 } else { y + 1 };
            if grid[x][t] == '.' {
              should_move.push((x, y))
            }
          }
        }
      }
      for (xc, yc) in should_move.into_iter() {
        let t = if yc == grid[0].len() - 1 { 0 } else { yc + 1 };
        if grid[xc][t] == '.' {
          grid[xc][t] = grid[xc][yc];
          grid[xc][yc] = '.';
        }
      }

      let mut should_move = vec![];
      for x in 0..grid.len() {
        for y in 0..grid[0].len() {
          if grid[x][y] == 'v' {
            let t = if x == grid.len() - 1 { 0 } else { x + 1 };
            if grid[t][y] == '.' {
              should_move.push((x, y))
            }
          }
        }
      }
      for (xc, yc) in should_move.into_iter() {
        let t = if xc == grid.len() - 1 { 0 } else { xc + 1 };
        grid[t][yc] = grid[xc][yc];
        grid[xc][yc] = '.';
      }
      step += 1;
      if previous_grid == grid {
        break;
      } else {
        previous_grid = grid.clone();
      }
      // println!("After {} step:", step);
      // display(&grid);
    }

    Some(step.to_string())
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
  fn test_day25_part1() {
    let prob = Day25 {};
    let input = indoc! {"v...>>.vv>
.vv>>.vv..
>>.>v>...v
>>v>>.>.v.
v>v.vv.v..
>.>>..v...
.vv..>.>v.
v.v..>>v.v
....v..v.>"};
    assert_eq!(prob.part1(input), None);
  }

  #[test]
  fn test_day25_part2() {
    let prob = Day25 {};
    let input = indoc! {""};
    assert_eq!(prob.part2(input), None);
  }
}
