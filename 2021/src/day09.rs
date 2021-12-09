use std::collections::HashSet;

use itertools::Itertools;

use crate::problem::Problem;

#[derive(Default)]
pub struct Day09 {}

impl Day09 {
}

fn fill_map(patterns: &str) -> Vec<String> {
  let mut unknown: Vec<HashSet<char>> = patterns.split(' ').map(|s| HashSet::from_iter(s.chars())).collect();
  unknown.sort_by(|a, b| a.len().partial_cmp(&b.len()).unwrap());
  let _1 = unknown[0].clone();
  let _4 = unknown[2].clone();
  let _7 = unknown[1].clone();
  let _8 = unknown[9].clone();
  unknown.retain(|x| x != &_8 && x != &_7 && x != &_4 && x != &_1);
  let _9 = unknown.iter().find(|s| _4.intersection(s).collect::<HashSet<_>>().len() == 4).unwrap().clone();
  unknown.retain(|x| x != &_9);
  let _3 = unknown.iter().find(|s| s.difference(&_7).collect::<HashSet<_>>().len() == 2).unwrap().clone();
  unknown.retain(|x| x != &_3);
  let _2 = unknown.iter().find(|s| _9.intersection(s).collect::<HashSet<_>>().len() == 4).unwrap().clone();
  unknown.retain(|x| x != &_2);
  let _0 = unknown.iter().find(|s| _1.intersection(s).collect::<HashSet<_>>().len() == 2).unwrap().clone();
  unknown.retain(|x| x != &_0);
  let _6 = unknown.iter().find(|s| s.len() == 6).unwrap().clone();
  unknown.retain(|x| x != &_6);
  let _5 = unknown.get(0).unwrap().clone();
  unknown.retain(|x| x != &_5);
  let map = vec![_0, _1, _2, _3, _4, _5, _6, _7, _8, _9];
  map.iter().map(|s| s.iter().sorted().collect::<String>()).collect()
}

impl Problem for Day09 {
  fn part1(&self, input: &str) -> Option<String> {
    Some(
      input
        .lines()
        .map(|l| {
          let (patterns, outputs) = l.split_once(" | ").unwrap();
          let map = fill_map(patterns);
          outputs
            .split(' ')
            .rev()
            .enumerate()
            .map(|(_, output)| {
              let output: String = output.chars().sorted().collect();
              let x = map.iter().find_position(|s| *s == &output.to_string()).unwrap().0;
              if x == 1 || x == 4 || x == 7 || x == 8 {
                1
              } else {
                0
              }
            })
            .sum::<usize>()
        })
        .sum::<usize>()
        .to_string(),
    )
  }

  fn part2(&self, input: &str) -> Option<String> {
    Some(
      input
        .lines()
        .map(|l| {
          let (patterns, outputs) = l.split_once(" | ").unwrap();
          let map = fill_map(patterns);
          outputs
            .split(' ')
            .rev()
            .enumerate()
            .map(|(i, output)| {
              let output: String = output.chars().sorted().collect();
              let x = map.iter().find_position(|s| *s == &output.to_string()).unwrap().0;
              (10 as usize).pow(i as u32) * x
            })
            .sum::<usize>()
        })
        .sum::<usize>()
        .to_string(),
    )
  }
}

#[cfg(test)]
mod tests {
  use indoc::indoc;

  use super::*;

  #[test]
  fn test_day09_part1() {
    let prob = Day09 {};
    let input = indoc! {"
    "};
    assert_eq!(prob.part1(input), None);
    assert_eq!(prob.part1(&crate::get_input(9)), None);
  }

  #[test]
  fn test_day09_part2() {
    let prob = Day09 {};
    let input = indoc! {"
    "};
    assert_eq!(prob.part2(input), None);
    assert_eq!(prob.part2(&crate::get_input(9)), None);
  }
}
