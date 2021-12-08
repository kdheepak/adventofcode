use itertools::Itertools;

use crate::problem::Problem;

#[derive(Default)]
pub struct Day08 {}

impl Day08 {
}

fn fill_map(patterns: &str) -> Vec<String> {
  let mut map = vec!["".to_string(); 10];
  for pattern in patterns.split(' ') {
    let pattern: String = pattern.chars().sorted().collect();
    if pattern.len() == 2 {
      map[1] = pattern;
    } else if pattern.len() == 4 {
      map[4] = pattern;
    } else if pattern.len() == 7 {
      map[8] = pattern;
    } else if pattern.len() == 3 {
      map[7] = pattern;
    }
  }
  for pattern in patterns.split(' ') {
    let pattern: String = pattern.chars().sorted().collect();
    if map.contains(&pattern) {
      continue;
    } else if pattern.chars().count() == 6 {
      if !map[1].chars().all(|p| pattern.contains(p)) {
        map[6] = pattern;
      } else if map[4].chars().all(|p| pattern.contains(p)) {
        map[9] = pattern;
      } else if !map[4].chars().all(|p| pattern.contains(p)) {
        map[0] = pattern;
      }
    } else if pattern.chars().count() == 5 && map[1].chars().all(|p| pattern.contains(p)) {
      map[3] = pattern;
    }
  }
  let c = map[1].chars().filter(|c| !(map[6].contains(*c))).sorted().next().unwrap();
  for pattern in patterns.split(' ') {
    let pattern: String = pattern.chars().sorted().collect();
    if map.contains(&pattern) {
      continue;
    } else if pattern.chars().count() == 5 {
      if !pattern.contains(c) {
        map[5] = pattern;
      } else {
        map[2] = pattern;
      }
    }
  }
  map
}

impl Problem for Day08 {
  fn part1(&self, input: &str) -> Option<String> {
    let all_patterns: Vec<&str> = input
      .lines()
      .map(|l| {
        let (patterns, _) = l.split_once(" | ").unwrap();
        patterns
      })
      .collect();

    let all_outputs: Vec<&str> = input
      .lines()
      .map(|l| {
        let (_, outputs) = l.split_once(" | ").unwrap();
        outputs
      })
      .collect();

    let mut map = vec![];
    for patterns in all_patterns {
      for pattern in patterns.split(' ') {
        let pattern: String = pattern.chars().sorted().collect();
        if pattern.len() == 2 || pattern.len() == 4 || pattern.len() == 7 || pattern.len() == 3 {
          map.push(pattern);
        }
      }
    }

    let mut count = 0;
    for outputs in all_outputs {
      for output in outputs.split(' ') {
        let output: String = output.chars().sorted().collect();
        if map.contains(&output) {
          count += 1;
        }
      }
    }
    Some(count.to_string())
  }

  fn part2(&self, input: &str) -> Option<String> {
    let lines: Vec<(&str, &str)> = input
      .lines()
      .map(|l| {
        let (patterns, outputs) = l.split_once(" | ").unwrap();
        (patterns, outputs)
      })
      .collect();

    let mut sum = 0;
    for (patterns, outputs) in lines {
      let map = fill_map(patterns);
      let mut num = vec![];
      for output in outputs.split(' ') {
        let output: String = output.chars().sorted().collect();
        let x = map.iter().find_position(|s| *s == &output.to_string()).unwrap();
        num.push(x.0);
      }
      let num: String = num.iter().map(|c| format!("{}", c)).collect();
      sum += num.parse::<usize>().unwrap();
    }

    Some(sum.to_string())
  }
}

#[cfg(test)]
mod tests {
  use indoc::indoc;

  use super::*;

  #[test]
  fn test_day08_part1() {
    let prob = Day08 {};
    let input = indoc! {"be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce"};
    assert_eq!(prob.part1(input), Some("26".to_string()));
    assert_eq!(prob.part1(&crate::get_input(8)), Some("318".to_string()));
  }

  #[test]
  fn test_day08_part2() {
    let prob = Day08 {};
    let input = indoc! {"be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce"};
    assert_eq!(prob.part2(input), Some("61229".to_string()));
    assert_eq!(prob.part2(&crate::get_input(8)), Some("996280".to_string()));
  }
}
