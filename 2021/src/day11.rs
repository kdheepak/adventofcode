use std::collections::HashMap;

use ansi_term::Style;
use itertools::Itertools;

use crate::problem::Problem;

#[derive(Default)]
pub struct Day11 {}

impl Day11 {
}

fn visualize_map(map: &[Vec<usize>], t: usize) {
  println!();
  println!("After step {}:", t + 1);
  for x in 0..map.len() {
    for y in 0..map[0].len() {
      if map[x][y] == 0 {
        print!("{}", Style::new().bold().paint(map[x][y].to_string()))
      } else {
        print!("{}", map[x][y])
      }
    }
    println!();
  }
}

impl Problem for Day11 {
  fn part1(&self, input: &str) -> Option<String> {
    let mut map = vec![];
    for line in input.lines() {
      map.push(line.chars().map(|c| c.to_string().parse::<usize>().unwrap()).collect::<Vec<_>>());
    }

    let dirs: Vec<(i64, i64)> = vec![(0, 1), (1, 0), (0, -1), (-1, 0), (1, 1), (1, -1), (-1, 1), (-1, -1)];
    let mut total = 0;
    for t in 0..100 {
      let mut should_flash = vec![];
      let mut flashed = vec![vec![false; map[0].len()]; map.len()];
      for x in 0..map.len() {
        for y in 0..map[0].len() {
          map[x][y] += 1;
          if map[x][y] > 9 {
            map[x][y] = 0;
            flashed[x][y] = true;
            should_flash.push((x as i64, y as i64));
            total += 1;
          }
        }
      }

      while !should_flash.is_empty() {
        let (x, y) = should_flash.remove(0);
        for (i, j) in dirs.iter() {
          if x + i >= 0
            && y + j >= 0
            && x + i < map.len() as i64
            && y + j < map[1].len() as i64
            && !flashed[(x + i) as usize][(y + j) as usize]
          {
            let (x, y) = ((x + i) as usize, (y + j) as usize);
            map[x][y] += 1;
            if map[x][y] > 9 {
              map[x][y] = 0;
              flashed[x][y] = true;
              should_flash.push((x as i64, y as i64));
              total += 1;
            }
          }
        }
      }
      // visualize_map(&map, t);
    }

    Some(total.to_string())
  }

  fn part2(&self, input: &str) -> Option<String> {
    let mut map = vec![];
    for line in input.lines() {
      map.push(line.chars().map(|c| c.to_string().parse::<usize>().unwrap()).collect::<Vec<_>>());
    }

    let dirs: Vec<(i64, i64)> = vec![(0, 1), (1, 0), (0, -1), (-1, 0), (1, 1), (1, -1), (-1, 1), (-1, -1)];
    let mut step = 0;
    loop {
      let mut total = 0;
      let mut should_flash = vec![];
      let mut flashed = vec![vec![false; map[0].len()]; map.len()];
      for x in 0..map.len() {
        for y in 0..map[0].len() {
          map[x][y] += 1;
          if map[x][y] > 9 {
            map[x][y] = 0;
            flashed[x][y] = true;
            should_flash.push((x as i64, y as i64));
            total += 1;
          }
        }
      }

      while !should_flash.is_empty() {
        let (x, y) = should_flash.remove(0);
        for (i, j) in dirs.iter() {
          if x + i >= 0
            && y + j >= 0
            && x + i < map.len() as i64
            && y + j < map[1].len() as i64
            && !flashed[(x + i) as usize][(y + j) as usize]
          {
            let (x, y) = ((x + i) as usize, (y + j) as usize);
            map[x][y] += 1;
            if map[x][y] > 9 {
              map[x][y] = 0;
              flashed[x][y] = true;
              should_flash.push((x as i64, y as i64));
              total += 1;
            }
          }
        }
      }
      step += 1;
      if total == map.len() * map[0].len() {
        break;
      }
    }

    Some(step.to_string())
  }
}

#[cfg(test)]
mod tests {
  use indoc::indoc;

  use super::*;

  #[test]
  fn test_day11_part1() {
    let prob = Day11 {};
    let input = indoc! {"5483143223
  2745854711
  5264556173
  6141336146
  6357385478
  4167524645
  2176841721
  6882881134
  4846848554
  5283751526"};
    assert_eq!(prob.part1(input), None);
    assert_eq!(prob.part1(&crate::get_input(11)), Some("1591".to_string()));
  }

  #[test]
  fn test_day11_part2() {
    let prob = Day11 {};
    let input = indoc! {"5483143223
  2745854711
  5264556173
  6141336146
  6357385478
  4167524645
  2176841721
  6882881134
  4846848554
  5283751526"};
    assert_eq!(prob.part2(input), None);
    assert_eq!(prob.part1(&crate::get_input(11)), Some("314".to_string()));
  }
}
