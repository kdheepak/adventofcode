use std::collections::HashMap;

use itertools::Itertools;

use crate::problem::Problem;

#[derive(Default)]
pub struct Day05 {}
type Line = (i64, i64, i64, i64);

impl Day05 {
  fn helper(&self, input: &str, diag: bool) -> Option<String> {
    let lines: Vec<Line> = input
      .lines()
      .filter_map(|l| {
        l.split(" -> ")
          .map(|s| s.split(','))
          .flatten()
          .map(|i| i.parse().unwrap())
          .collect_tuple()
      })
      .collect();

    let mut map = HashMap::new();

    for d in lines.iter().filter(|d| diag || !(d.0 != d.2 && d.1 != d.3)) {
      let (x1, y1, x2, y2) = (d.0, d.1, d.2, d.3);
      let dx = (x2 - x1).signum();
      let dy = (y2 - y1).signum();
      let (mut x, mut y) = (x1, y1);
      while (x, y) != (x2 + dx, y2 + dy) {
        *map.entry((x as usize, y as usize)).or_insert(0) += 1;
        x += dx;
        y += dy;
      }
    }
    Some((map.values().filter(|v| **v > 1).count()).to_string())
  }
}

impl Problem for Day05 {
  fn part1(&self, input: &str) -> Option<String> {
    self.helper(input, false)
  }

  fn part2(&self, input: &str) -> Option<String> {
    self.helper(input, true)
  }
}

#[cfg(test)]
mod tests {
  use indoc::indoc;

  use super::*;

  #[test]
  fn test_day05_part1() {
    let prob = Day05 {};
    let input = indoc! {"
        0,9 -> 5,9
        8,0 -> 0,8
        9,4 -> 3,4
        2,2 -> 2,1
        7,0 -> 7,4
        6,4 -> 2,0
        0,9 -> 2,9
        3,4 -> 1,4
        0,0 -> 8,8
        5,5 -> 8,2
    "};
    assert_eq!(prob.part1(input), Some("5".to_string()));

    assert_eq!(prob.part1(&crate::get_input(5)), Some("5690".to_string()));
  }

  #[test]
  fn test_day05_part2() {
    let prob = Day05 {};
    let input = indoc! {"
        0,9 -> 5,9
        8,0 -> 0,8
        9,4 -> 3,4
        2,2 -> 2,1
        7,0 -> 7,4
        6,4 -> 2,0
        0,9 -> 2,9
        3,4 -> 1,4
        0,0 -> 8,8
        5,5 -> 8,2
    "};
    assert_eq!(prob.part2(input), Some("12".to_string()));

    assert_eq!(prob.part2(&crate::get_input(5)), Some("17741".to_string()));
  }
}
