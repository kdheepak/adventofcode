use serde_scan::scan;

use crate::problem::Problem;

#[derive(Default)]
pub struct Day02 {}

impl Problem for Day02 {
  fn part1(&self, input: &str) -> Option<String> {
    let lines: Vec<(&str, usize)> = input.lines().map(|line| scan!("{} {}" <- line).unwrap()).collect();
    let (mut depth, mut position) = (0, 0);
    for (dir, mag) in lines {
      match dir {
        "forward" => position += mag,
        "down" => depth += mag,
        "up" => depth -= mag,
        _ => panic!("unknown dir {}", dir),
      }
    }
    Some((depth * position).to_string())
  }

  fn part2(&self, input: &str) -> Option<String> {
    let lines: Vec<(&str, usize)> = input.lines().map(|line| scan!("{} {}" <- line).unwrap()).collect();
    let (mut depth, mut position, mut aim) = (0, 0, 0);
    for (dir, mag) in lines {
      match dir {
        "forward" => {
          position += mag;
          depth += aim * mag;
        },
        "down" => aim += mag,
        "up" => aim -= mag,
        _ => panic!("unknown dir {}", dir),
      }
    }
    Some((depth * position).to_string())
  }
}

#[cfg(test)]
mod tests {
  use indoc::indoc;

  use super::*;

  #[test]
  fn test_day02_part1() {
    let input = indoc! {"
            forward 5
            down 5
            forward 8
            up 3
            down 8
            forward 2
        "};
    let prob = Day02 {};

    assert_eq!(prob.part1(input), Some("150".to_string()));

    assert_eq!(prob.part1(&crate::get_input(1)), Some("1480518".to_string()));
  }

  #[test]
  fn test_day02_part2() {
    let input = indoc! {"
            forward 5
            down 5
            forward 8
            up 3
            down 8
            forward 2
        "};
    let prob = Day02 {};

    assert_eq!(prob.part2(input), Some("900".to_string()));

    assert_eq!(prob.part2(&crate::get_input(1)), Some("1282809906".to_string()));
  }
}
