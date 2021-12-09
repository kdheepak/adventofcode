use std::collections::{HashMap, HashSet};

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
    let mut visited = vec![vec![false; map[0].len()]; map.len()];
    let mut counter = 0;
    for i in 0..map.len() {
      for j in 0..map[i].len() {
        if map[i][j] != 9 && !visited[i][j] {
          counter += 1;
          *basins.entry(counter).or_insert(0) = dfs(&mut map, &mut visited, i, j);
        }
      }
    }
    let mut basins = basins.values().sorted().rev();
    let b1 = basins.next().unwrap();
    let b2 = basins.next().unwrap();
    let b3 = basins.next().unwrap();
    Some((b1 * b2 * b3).to_string())
  }
}

fn dfs(map: &mut Vec<Vec<usize>>, visited: &mut Vec<Vec<bool>>, x: usize, y: usize) -> usize {
  if x >= visited.len() || y >= visited[0].len() || visited[x][y] || map[x][y] == 9 {
    return 0;
  } else {
    visited[x][y] = true;
    map[x][y] = 9;
  }
  1 + dfs(map, visited, x, y + 1)
    + dfs(map, visited, x, y.saturating_sub(1))
    + dfs(map, visited, x + 1, y)
    + dfs(map, visited, x.saturating_sub(1), y)
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
    // assert_eq!(prob.part1(&crate::get_input(9)), None);
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
    assert_eq!(prob.part2(&crate::get_input(9)), None);
  }
}
