use crate::problem::Problem;

use nalgebra::DMatrix;
use serde_scan::scan;

use std::cmp::max;

#[derive(Default)]
pub struct Day05 {}

struct Line {
    x1: i64,
    y1: i64,
    x2: i64,
    y2: i64,
}

impl Day05 {
    fn parse(&self, input: &str) -> Vec<Line> {
        input
            .lines()
            .map(|l| scan!("{},{} -> {},{}" <- l).unwrap())
            .map(|(x1, y1, x2, y2)| Line { x1, y1, x2, y2 })
            .collect()
    }

    fn helper(&self, input: &str, part: usize) -> Option<String> {
        let lines = self.parse(input);

        let max_x = lines
            .iter()
            .map(|d| max(d.x1, d.x2))
            .reduce(max)
            .expect("Unable to get max x")
            + 1;
        let max_y = lines
            .iter()
            .map(|d| max(d.y1, d.y2))
            .reduce(max)
            .expect("Unable to get max y")
            + 1;

        let mut map: DMatrix<usize> = DMatrix::zeros(max_x as usize, max_y as usize);

        for d in lines.iter() {
            let Line { x1, y1, x2, y2 } = d;
            if part == 1 && (x1 != x2 && y1 != y2) {
                continue;
            }
            let dx = (x2 - x1).signum();
            let dy = (y2 - y1).signum();
            let (mut x, mut y) = (*x1, *y1);
            while (x, y) != (*x2 + dx, *y2 + dy) {
                *map.get_mut((x as usize, y as usize))
                    .unwrap_or_else(|| panic!("Cannot index {:?}", (x, y))) += 1;
                x += dx;
                y += dy;
            }
        }
        Some((map.iter().filter(|v| **v > 1).count()).to_string())
    }
}

impl Problem for Day05 {
    fn part1(&self, input: &str) -> Option<String> {
        self.helper(input, 1)
    }

    fn part2(&self, input: &str) -> Option<String> {
        self.helper(input, 2)
    }
}

#[test]
fn test_day05_part1() {
    let prob = Day05 {};
    let input = r#"0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2"#;
    let ans = prob.part1(input);
    assert_eq!(ans, Some("5".to_string()));

    assert_eq!(prob.part1(&crate::get_input(5)), Some("5690".to_string()));
}

#[test]
fn test_day05_part2() {
    let prob = Day05 {};
    let input = r#"0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2"#;
    let ans = prob.part2(input);
    assert_eq!(ans, Some("12".to_string()));

    assert_eq!(prob.part2(&crate::get_input(5)), Some("17741".to_string()));
}
