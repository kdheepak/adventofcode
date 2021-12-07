use crate::problem::Problem;
use itertools::Itertools;

#[derive(Default)]
pub struct Day07 {}

impl Day07 {
}

impl Problem for Day07 {
  fn part1(&self, input: &str) -> Option<String> {
    let positions: Vec<i32> = input.split(',').map(|p| p.parse().unwrap()).collect();
    let (min, max) = positions.iter().minmax().into_option().unwrap();
    (*min..=*max)
      .map(|pos| positions.iter().fold(0, |acc, p| acc + (p - pos).abs()))
      .min()
      .map(|x| x.to_string())
  }

  fn part2(&self, input: &str) -> Option<String> {
    let positions: Vec<i32> = input.split(',').map(|p| p.parse().unwrap()).collect();
    let (min, max) = positions.iter().minmax().into_option().unwrap();
    (*min..=*max)
      .map(|pos| positions.iter().fold(0, |acc, p| acc + (p - pos).abs() * ((p - pos).abs() + 1) / 2))
      .min()
      .map(|x| x.to_string())
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
