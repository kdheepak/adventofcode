use std::{
  cmp::Ordering,
  collections::{BinaryHeap, HashMap, HashSet, VecDeque},
};

use ansi_term::Style;
use itertools::Itertools;

use crate::problem::Problem;

#[derive(Default)]
pub struct Day15 {}

impl Day15 {
}

#[derive(Copy, Clone, Eq, PartialEq)]
struct State {
  cost: usize,
  position: (i64, i64),
}

// The priority queue depends on `Ord`.
// Explicitly implement the trait so the queue becomes a min-heap
// instead of a max-heap.
impl Ord for State {
  fn cmp(&self, other: &Self) -> Ordering {
    // Notice that the we flip the ordering on costs.
    // In case of a tie we compare positions - this step is necessary
    // to make implementations of `PartialEq` and `Ord` consistent.
    other.cost.cmp(&self.cost).then_with(|| self.position.cmp(&other.position))
  }
}

// `PartialOrd` needs to be implemented as well.
impl PartialOrd for State {
  fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
    Some(self.cmp(other))
  }
}

fn solve(map: Vec<Vec<usize>>) -> i64 {
  let mut heap = BinaryHeap::new();
  let mut seen = HashSet::new();
  heap.push(State { cost: 0, position: (0, 0) });
  while let Some(State { cost, position }) = heap.pop() {
    let (x, y) = position;
    if !seen.insert((x, y)) {
      continue;
    }
    for (dx, dy) in [(0, 1), (1, 0), (-1, 0), (0, -1)] {
      let new_x = x + dx;
      let new_y = y + dy;
      if new_x >= 0 && new_x < map.len() as i64 && new_y >= 0 && new_y < map[0].len() as i64 {
        let r = map[new_x as usize][new_y as usize];
        if (new_x, new_y) == ((map.len() - 1) as i64, (map[0].len() - 1) as i64) {
          return (cost + r) as i64;
        }
        heap.push(State { cost: cost + r, position: (new_x, new_y) });
      }
    }
  }
  panic!("no path found")
}

impl Problem for Day15 {
  fn part1(&self, input: &str) -> Option<String> {
    let map: Vec<Vec<usize>> =
      input.lines().map(|line| line.chars().map(|c| c.to_string().parse::<usize>().unwrap()).collect()).collect();

    let r = solve(map);
    Some(r.to_string())
  }

  fn part2(&self, input: &str) -> Option<String> {
    let map: Vec<Vec<usize>> =
      input.lines().map(|line| line.chars().map(|c| c.to_string().parse::<usize>().unwrap()).collect()).collect();

    let mut new_map = vec![vec![0; map[0].len() * 5]; map.len() * 5];

    for (ix, iy) in (0..5).cartesian_product(0..5) {
      for (x, y) in (0..map.len()).cartesian_product(0..map[0].len()) {
        let r = if map[x][y] + ix + iy > 9 { map[x][y] + ix + iy - 9 } else { map[x][y] + ix + iy };
        new_map[x + ix * map.len()][y + iy * map[0].len()] = r;
      }
    }

    let r = solve(new_map);
    Some(r.to_string())
  }
}

#[cfg(test)]
mod tests {
  use indoc::indoc;

  use super::*;
  use crate::get_input;

  #[test]
  fn test_day15_part1() {
    let prob = Day15 {};
    let input = indoc! {"1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581"};
    assert_eq!(prob.part1(input), Some("40".to_string()));
    assert_eq!(prob.part1(&get_input(15)), Some("423".to_string()));
  }

  #[test]
  fn test_day15_part2() {
    let prob = Day15 {};
    let input = indoc! {"1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581"};
    assert_eq!(prob.part2(input), Some("315".to_string()));
    assert_eq!(prob.part2(&get_input(15)), Some("2778".to_string()));
  }
}
