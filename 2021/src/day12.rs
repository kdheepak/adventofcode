use std::collections::{HashMap, VecDeque};

use ansi_term::Style;
use itertools::Itertools;

use crate::problem::Problem;

#[derive(Default)]
pub struct Day12 {}

impl Day12 {
}

impl Problem for Day12 {
  fn part1(&self, input: &str) -> Option<String> {
    let mut map = HashMap::new();
    for line in input.lines() {
      let (from, to) = line.split_once("-").unwrap();
      (*map.entry(from.to_string()).or_insert_with(Vec::new)).push(to);
      (*map.entry(to.to_string()).or_insert_with(Vec::new)).push(from);
    }
    let mut q = VecDeque::new();
    q.push_back(("start".to_string(), vec!["start".to_string()]));
    let mut ans: usize = 0;
    while !q.is_empty() {
      let (node, visited) = q.pop_front().unwrap();
      let node = node.clone();

      if node.as_str() == "end" {
        ans += 1;
        continue;
      } else {
        let ns = map.get(&(node.to_string())).unwrap();
        for n in ns.iter() {
          if !visited.contains(&n.to_string()) {
            let mut new_visited = visited.clone();
            if *n == n.to_lowercase() {
              new_visited.push(n.to_string())
            }
            q.push_back((n.to_string(), new_visited));
          }
        }
      }
    }

    Some(ans.to_string())
  }

  fn part2(&self, input: &str) -> Option<String> {
    let mut map = HashMap::new();
    for line in input.lines() {
      let (from, to) = line.split_once("-").unwrap();
      (*map.entry(from.to_string()).or_insert_with(Vec::new)).push(to);
      (*map.entry(to.to_string()).or_insert_with(Vec::new)).push(from);
    }
    let mut q = VecDeque::new();
    q.push_back(("start".to_string(), vec!["start".to_string()], false));
    let mut ans: usize = 0;
    while !q.is_empty() {
      let (node, visited, seen_twice) = q.pop_front().unwrap();
      let node = node.clone();

      if node.as_str() == "end" {
        ans += 1;
        continue;
      } else {
        let ns = map.get(&(node.to_string())).unwrap();
        for n in ns.iter() {
          if !visited.contains(&n.to_string()) {
            let mut new_visited = visited.clone();
            if *n == n.to_lowercase() {
              new_visited.push(n.to_string())
            }
            q.push_back((n.to_string(), new_visited, seen_twice));
          } else if !seen_twice
            && visited.iter().filter(|node| node == n).count() == 1
            && !vec!["start".to_string(), "end".to_string()].contains(&(n.to_string()))
          {
            q.push_back((n.to_string(), visited.clone(), true));
          }
        }
      }
    }

    Some(ans.to_string())
  }
}

#[cfg(test)]
mod tests {
  use indoc::indoc;

  use super::*;

  #[test]
  fn test_day12_part1() {
    let prob = Day12 {};
    let input = indoc! {"start-A
start-b
A-c
A-b
b-d
A-end
b-end"};
    assert_eq!(prob.part1(input), Some("10".to_string()));
    let input = indoc! {"dc-end
HN-start
start-kj
dc-start
dc-HN
LN-dc
HN-end
kj-sa
kj-HN
kj-dc"};
    assert_eq!(prob.part1(input), Some("19".to_string()));
    let input = indoc! {"fs-end
he-DX
fs-he
start-DX
pj-DX
end-zg
zg-sl
zg-pj
pj-he
RW-he
fs-DX
pj-RW
zg-RW
start-pj
he-WI
zg-he
pj-fs
start-RW"};
    assert_eq!(prob.part1(input), Some("226".to_string()));
    assert_eq!(prob.part1(&crate::get_input(12)), Some("3497".to_string()));
  }

  #[test]
  fn test_day12_part2() {
    let prob = Day12 {};
    let input = indoc! {"start-A
start-b
A-c
A-b
b-d
A-end
b-end"};
    assert_eq!(prob.part2(input), Some("36".to_string()));
    let input = indoc! {"dc-end
HN-start
start-kj
dc-start
dc-HN
LN-dc
HN-end
kj-sa
kj-HN
kj-dc"};
    assert_eq!(prob.part2(input), Some("103".to_string()));
    let input = indoc! {"fs-end
he-DX
fs-he
start-DX
pj-DX
end-zg
zg-sl
zg-pj
pj-he
RW-he
fs-DX
pj-RW
zg-RW
start-pj
he-WI
zg-he
pj-fs
start-RW"};
    assert_eq!(prob.part2(input), Some("3509".to_string()));
    assert_eq!(prob.part2(&crate::get_input(12)), Some("93686".to_string()));
  }
}
