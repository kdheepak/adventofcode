use itertools::Itertools;

use crate::problem::Problem;

#[derive(Default)]
pub struct Day08 {}

impl Day08 {
}

impl Problem for Day08 {
  fn part1(&self, input: &str) -> Option<String> {
    None
  }

  fn part2(&self, input: &str) -> Option<String> {
    None
  }
}

#[cfg(test)]
mod tests {
  use indoc::indoc;

  use super::*;

  #[test]
  fn test_day08() {
    let prob = Day08 {};
    let input = indoc! {"16,1,2,0,4,2,7,1,2,14"};
    assert_eq!(prob.part1(input), None);
    assert_eq!(prob.part1(&crate::get_input(7)), None);
  }

  #[test]
  fn test_day08() {
    let prob = Day08 {};
    let input = indoc! {"16,1,2,0,4,2,7,1,2,14"};
    assert_eq!(prob.part2(input), None);
    assert_eq!(prob.part2(&crate::get_input(8)), None);
  }
}
