use ansi_term::Style;
use itertools::Itertools;

use crate::problem::Problem;

#[derive(Default)]
pub struct Day06 {}

impl Day06 {
}

impl Problem for Day06 {
  fn part1(&self, input: &str) -> Option<String> {
    let mut fish: Vec<usize> = input.split(',').map(|x| x.parse().unwrap()).collect();

    let mut day = 0;
    while day < 80 {
      let mut update = vec![];
      for f in fish.iter_mut() {
        if *f == 0 {
          *f = 6;
          update.push(8);
        } else {
          *f -= 1;
        }
      }
      for f in update {
        fish.push(f);
      }
      day += 1;
    }
    Some(fish.len().to_string())
  }

  fn part2(&self, input: &str) -> Option<String> {
    let fish: Vec<usize> = input.split(',').map(|x| x.parse().unwrap()).collect();
    let mut counter = vec![0; 9];

    // initialization
    for f in fish {
      counter[f] += 1;
    }

    for _ in 0..256 {
      let f = counter[0];
      for i in 0..counter.len() {
        if i == (counter.len() - 1) {
          counter[i] = f;
        } else {
          counter[i] = counter[i + 1]
        }
      }
      counter[6] += f;
    }

    Some(counter.iter().sum::<usize>().to_string())
  }
}

#[cfg(test)]
mod tests {
  use indoc::indoc;

  use super::*;

  #[test]
  fn test_day06_part1() {
    let prob = Day06 {};
    let input = indoc! {"3,4,3,1,2"};
    assert_eq!(prob.part1(input), Some("5934".to_string()));
    assert_eq!(prob.part1(&crate::get_input(6)), Some("396210".to_string()));
  }

  #[test]
  fn test_day06_part2() {
    let prob = Day06 {};
    let input = indoc! {"3,4,3,1,2"};
    assert_eq!(prob.part2(input), Some("26984457539".to_string()));
    assert_eq!(prob.part2(&crate::get_input(6)), Some("1770823541496".to_string()));
  }
}
