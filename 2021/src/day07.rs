use crate::problem::Problem;

#[derive(Default)]
pub struct Day07 {}

impl Day07 {
}

impl Problem for Day07 {
  fn part1(&self, input: &str) -> Option<String> {
    let positions: Vec<usize> = input.split(",").map(|p| p.parse().unwrap()).collect();

    let mut fuel = vec![];
    for pos in positions.iter() {
      fuel.push(
        positions
          .iter()
          .map(|p| if p >= pos { p - pos } else { pos - p })
          .reduce(|a, b| a + b),
      )
    }
    Some(fuel.iter().reduce(|a, b| a.min(b)).unwrap().unwrap().to_string())
  }

  fn part2(&self, input: &str) -> Option<String> {
    let positions: Vec<usize> = input.split(',').map(|p| p.parse().unwrap()).collect();

    let mut fuel = vec![];
    let min = *positions.iter().min().unwrap();
    let max = *positions.iter().max().unwrap();
    for pos in min..=max {
      fuel.push(
        positions
          .iter()
          .map(|p| {
            if p >= &pos {
              let n = p - pos;
              n * (n + 1) / 2
            } else {
              let n = pos - p;
              n * (n + 1) / 2
            }
          })
          .reduce(|a, b| a + b),
      )
    }
    Some(fuel.iter().reduce(|a, b| a.min(b)).unwrap().unwrap().to_string())
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
    // assert_eq!(prob.part2(&crate::get_input(7)), Some("344735".to_string()));
  }
}
