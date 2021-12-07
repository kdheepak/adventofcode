use crate::problem::Problem;

#[derive(Default)]
pub struct Day07 {}

impl Day07 {
}

impl Problem for Day07 {
  fn part1(&self, input: &str) -> Option<String> {
    let positions = input.split(',').map(|p| p.parse::<i32>().unwrap()).collect::<Vec<_>>();
    (*positions.iter().min().unwrap()..=*positions.iter().max().unwrap())
      .map(|pos| positions.iter().fold(0, |acc, p| acc + (p - pos) * (p - pos).signum()))
      .min()
      .map(|x| x.to_string())
  }

  fn part2(&self, input: &str) -> Option<String> {
    let positions = input.split(',').map(|p| p.parse::<i32>().unwrap()).collect::<Vec<_>>();
    (*positions.iter().min().unwrap()..=*positions.iter().max().unwrap())
      .map(|pos| {
        positions.iter().fold(0, |acc, p| {
          let n = (p - pos) * (p - pos).signum();
          acc + n * (n + 1) / 2
        })
      })
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
