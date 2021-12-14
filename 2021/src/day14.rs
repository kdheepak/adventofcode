use std::collections::{HashMap, VecDeque};

use ansi_term::Style;
use itertools::Itertools;

use crate::problem::Problem;

#[derive(Default)]
pub struct Day14 {}

impl Day14 {
}

impl Problem for Day14 {
  fn part1(&self, input: &str) -> Option<String> {
    let (template, pairs) = input.split_once("\n\n").unwrap();
    let mut rules = HashMap::new();
    for (rule, insertion) in pairs.lines().map(|line| line.split_once(" -> ").unwrap()) {
      *rules.entry(rule).or_default() = insertion;
    }

    let mut template = template.to_string();

    for step in 0..10 {
      let mut insertions = vec![];

      for (i, (c1, c2)) in template.chars().tuple_windows().enumerate() {
        if let Some(v) = rules.get(format!("{}{}", c1, c2).as_str()) {
          insertions.push((i, v))
        }
      }
      for (i, v) in insertions.iter().rev() {
        template.insert(*i + 1, v.chars().next().unwrap());
      }
    }

    let ans = template
      .chars()
      .sorted()
      .dedup()
      .map(|c| template.chars().filter(|v| *v == c).count())
      .sorted()
      .collect::<Vec<usize>>();
    Some((ans.last().unwrap() - ans.first().unwrap()).to_string())
  }

  fn part2(&self, input: &str) -> Option<String> {
    let (template, pairs) = input.split_once("\n\n").unwrap();
    let mut rules = HashMap::new();
    for (rule, insertion) in pairs.lines().map(|line| line.split_once(" -> ").unwrap()) {
      let mut chars = rule.chars();
      let (c1, c2) = (chars.next().unwrap(), chars.next().unwrap());
      *rules.entry((c1, c2)).or_default() = insertion.chars().next().unwrap();
    }
    let mut counts = template.chars().tuple_windows().counts();
    for _ in 0..40 {
      let mut tmp = HashMap::new();
      for (&(a, b), count) in &counts {
        let c = rules.get(&(a, b)).unwrap();
        *tmp.entry((a, *c)).or_insert(0) += count;
        *tmp.entry((*c, b)).or_insert(0) += count;
      }
      counts = tmp
    }
    let mut count = HashMap::new();
    for (&(c1, _), v) in &counts {
      *count.entry(c1).or_insert(0) += v;
    }
    *count.entry(template.chars().last().unwrap()).or_insert(0) += 1;
    let max = count.values().max().unwrap();
    let min = count.values().min().unwrap();
    Some((max - min).to_string())
  }
}

fn reduce_rules1(rules: &mut HashMap<&str, String>, _: &str) {
  let mut updates = vec![];
  for (k1, v1) in rules.iter() {
    let mut insertions = vec![];
    for (i, (c1, c2)) in k1.chars().tuple_windows().enumerate() {
      if let Some(v) = rules.get(format!("{}{}", c1, c2).as_str()) {
        insertions.push((i, v))
      }
    }
    let mut copy = String::new();
    for (i, v) in insertions.iter().rev() {
      let (a, c) = k1.split_at(*i + 1);
      copy = format!("{}{}{}", a, v, c);
    }
    updates.push((k1.to_owned(), copy));
  }

  for (k, v) in updates.iter() {
    *rules.entry(k).or_default() = v.to_string();
  }
}

fn reduce_rules2(rules: &mut HashMap<&str, String>, _: &str) {
  let mut updates = vec![];
  for (k1, v1) in rules.iter() {
    let mut insertions = vec![];
    for (i, (c1, c2)) in v1.chars().tuple_windows().enumerate() {
      if let Some(v) = rules.get(format!("{}{}", c1, c2).as_str()) {
        insertions.push((i, v))
      }
    }
    let mut copy = String::new();
    for (i, v) in insertions.iter().rev() {
      let (a, c) = v1.split_at(*i + 1);
      copy = format!("{}{}{}", a, v, c);
    }
    updates.push((k1.to_owned(), copy));
  }

  for (k, v) in updates.iter() {
    *rules.entry(k).or_default() = v.to_string();
  }
}

#[cfg(test)]
mod tests {
  use indoc::indoc;

  use super::*;

  #[test]
  fn test_day14_part1() {
    let prob = Day14 {};
    let input = indoc! {"NNCB

  CH -> B
  HH -> N
  CB -> H
  NH -> C
  HB -> C
  HC -> B
  HN -> C
  NN -> C
  BH -> H
  NC -> B
  NB -> B
  BN -> B
  BB -> N
  BC -> B
  CC -> N
  CN -> C"};
    assert_eq!(prob.part1(input), None);
  }

  #[test]
  fn test_day14_part2() {
    let prob = Day14 {};
    let input = indoc! {"NNCB

  CH -> B
  HH -> N
  CB -> H
  NH -> C
  HB -> C
  HC -> B
  HN -> C
  NN -> C
  BH -> H
  NC -> B
  NB -> B
  BN -> B
  BB -> N
  BC -> B
  CC -> N
  CN -> C"};
    assert_eq!(prob.part2(input), None);
  }
}
