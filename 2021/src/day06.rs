use crate::problem::Problem;

#[derive(Default)]
pub struct Day06 {}

impl Day06 {
}

fn helper(input: &str, days: usize) -> usize {
    let fish: Vec<usize> = input.split(',').map(|x| x.parse().unwrap()).collect();
    let mut counter = vec![0; 9];
    // initialization
    for f in fish { counter[f] += 1 }
    for _ in 0..days {
      counter.rotate_left(1);
      counter[6]+=counter[8];
    }
    counter.iter().sum()
}

impl Problem for Day06 {
  fn part1(&self, input: &str) -> Option<String> {
    Some(helper(input, 80).to_string())
  }

  fn part2(&self, input: &str) -> Option<String> {
    Some(helper(input, 256).to_string())
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
