use crate::problem::Problem;

#[derive(Default)]
pub struct Day03 {}

fn has_most_common_bit(bits: &[usize], bit: usize) -> bool {
  let mut total = [0, 0];
  for item in bits {
    total[(item >> bit) & 1] += 1;
  }
  total[1] >= total[0]
}

fn helper(input: &str, is_oxygen: bool) -> usize {
  let n = input.lines().next().unwrap().chars().count();
  let mut bits = input
    .lines()
    .map(|item| usize::from_str_radix(item, 2).unwrap())
    .collect::<Vec<_>>();
  for i in (0..n).rev() {
    let keep = if is_oxygen {
      has_most_common_bit(&bits, i) as usize
    } else {
      !has_most_common_bit(&bits, i) as usize
    };
    bits.retain(|item| ((item >> i) & 1) == keep);
    if bits.len() == 1 {
      break;
    }
  }

  bits[0]
}

impl Problem for Day03 {
  fn part1(&self, input: &str) -> Option<String> {
    let n = input.lines().next().unwrap().chars().count();
    let bits = input
      .lines()
      .map(|item| usize::from_str_radix(item, 2).unwrap())
      .collect::<Vec<_>>();

    let gamma: usize = (0..n)
      .rev()
      .map(|i| (has_most_common_bit(&bits, i) as usize) << i)
      .sum();
    let base: u32 = 2;
    let epsilon = (!gamma) & (base.pow(n as u32) as usize - 1);
    Some((gamma * epsilon).to_string())
  }

  fn part2(&self, input: &str) -> Option<String> {
    let oxygen = helper(input, true);
    let co2 = helper(input, false);
    Some((oxygen * co2).to_string())
  }
}

#[cfg(test)]
mod tests {
  use indoc::indoc;

  use super::*;

  #[test]
  fn test_day03_part1() {
    let prob = Day03 {};

    let input = indoc! {"
      00100
      11110
      10110
      10111
      10101
      01111
      00111
      11100
      10000
      11001
      00010
      01010
    "};

    assert_eq!(prob.part1(input), Some("198".into()));
    assert_eq!(prob.part1(&crate::get_input(3)), Some("2035764".into()));
  }

  #[test]
  fn test_day03_part2() {
    let prob = Day03 {};

    let input = indoc! {"
      00100
      11110
      10110
      10111
      10101
      01111
      00111
      11100
      10000
      11001
      00010
      01010
    "};

    assert_eq!(prob.part2(input), Some("230".into()));
    assert_eq!(prob.part2(&crate::get_input(3)), Some("2817661".into()));
  }
}
