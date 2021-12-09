use std::collections::HashMap;

use itertools::Itertools;

use crate::problem::Problem;

#[derive(Default)]
pub struct Day09 {}

impl Day09 {
}

impl Problem for Day09 {
  fn part1(&self, input: &str) -> Option<String> {
    let mut map = vec![];
    for line in input.lines() {
      map.push(line.chars().map(|c| c.to_string().parse::<usize>().unwrap()).collect::<Vec<_>>());
    }
    let mut sum = 0;
    for (i, row) in map.iter().enumerate() {
      for (j, col) in row.iter().enumerate() {
        if i < map.len() {
          if let Some(r) = map.get(i + 1) {
            if let Some(c) = r.get(j) {
              if col >= c {
                continue;
              }
            }
          }
        }
        if i > 0 {
          if let Some(r) = map.get(i - 1) {
            if let Some(c) = r.get(j) {
              if col >= c {
                continue;
              }
            }
          }
        }
        if j > 0 {
          if let Some(r) = map.get(i) {
            if let Some(c) = r.get(j - 1) {
              if col >= c {
                continue;
              }
            }
          }
        }
        if j < row.len() {
          if let Some(r) = map.get(i) {
            if let Some(c) = r.get(j + 1) {
              if col >= c {
                continue;
              }
            }
          }
        }
        sum += col + 1
      }
    }
    Some(sum.to_string())
  }

  fn part2(&self, input: &str) -> Option<String> {
    let mut map = vec![];
    for line in input.lines() {
      map.push(line.chars().map(|c| c.to_string().parse::<usize>().unwrap()).collect::<Vec<_>>());
    }
    let mut basins = HashMap::new();
    let mut counter = 0;
    for i in 0..map.len() {
      for j in 0..map[i].len() {
        if map[i][j] != 9 {
          counter += 1;
          *basins.entry(counter).or_insert(0) = dfs(&mut map, i, j);
        }
      }
    }
    let ans = basins.values().sorted().rev().cloned().collect::<Vec<_>>()[0..3].iter().product::<usize>();
    Some(ans.to_string())
  }
}

fn dfs(map: &mut Vec<Vec<usize>>, x: usize, y: usize) -> usize {
  if x >= map.len() || y >= map[0].len() || map[x][y] == 9 {
    return 0;
  } else {
    map[x][y] = 9;
  }
  1 + dfs(map, x, y + 1) + dfs(map, x, y.saturating_sub(1)) + dfs(map, x + 1, y) + dfs(map, x.saturating_sub(1), y)
}

#[cfg(test)]
mod tests {
  use indoc::indoc;

  use super::*;

  #[test]
  fn test_day09_part1() {
    let prob = Day09 {};
    let input = indoc! {"2199943210
3987894921
9856789892
8767896789
9899965678"};
    assert_eq!(prob.part1(input), Some("15".to_string()));
    assert_eq!(prob.part1(&crate::get_input(9)), Some("468".to_string()));
  }

  #[test]
  fn test_day09_part2() {
    let prob = Day09 {};
    let input = indoc! {"2199943210
3987894921
9856789892
8767896789
9899965678"};
    assert_eq!(prob.part2(input), Some("1134".to_string()));
    assert_eq!(prob.part2(&crate::get_input(9)), Some("1280496".to_string()));
  }
}
