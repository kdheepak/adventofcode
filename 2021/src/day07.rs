use itertools::Itertools;

use crate::problem::Problem;

#[derive(Default)]
pub struct Day07 {}

impl Day07 {
}

impl Problem for Day07 {
  fn part1(&self, input: &str) -> Option<String> {
    let positions: Vec<i32> = input.split(',').map(|p| p.parse().unwrap()).collect();
    let (min, max) = positions.iter().minmax().into_option()?;
    (*min..=*max)
      .map(|p1| positions.iter().cloned().reduce(|acc, p2| acc + (p2 - p1).abs()))
      .min()
      .map(|x| x.unwrap().to_string())
  }

  fn part2(&self, input: &str) -> Option<String> {
    let positions: Vec<i32> = input.split(',').map(|p| p.parse().unwrap()).collect();
    let (min, max) = positions.iter().minmax().into_option()?;
    (*min..=*max)
      .map(|p1| positions.iter().cloned().reduce(|acc, p2| acc + (p2 - p1).abs() * ((p2 - p1).abs() + 1) / 2))
      .min()
      .map(|x| x.unwrap().to_string())
  }
}

#[cfg(test)]
mod tests {
  use indoc::indoc;

  use super::*;

  #[test]
  fn test_day07_part1() {
    let prob = Day07 {};
    let input = indoc! {"16,1,2,0,4,2,7,1,2,14"};
    assert_eq!(prob.part1(input), Some("37".to_string()));
    assert_eq!(prob.part1(&crate::get_input(7)), Some("344735".to_string()));
  }

  #[test]
  fn test_day07_part2() {
    let prob = Day07 {};
    let input = indoc! {"16,1,2,0,4,2,7,1,2,14"};
    assert_eq!(prob.part2(input), Some("168".to_string()));
    assert_eq!(prob.part2(&crate::get_input(7)), Some("96798233".to_string()));
  }
}
