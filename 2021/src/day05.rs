#![feature(iter_zip)]
use std::collections::HashMap;

use crate::problem::Problem;

use nalgebra::DMatrix;
use serde_scan::scan;

#[derive(Default)]
pub struct Day05 {}

impl Problem for Day05 {
    fn part_one(&self, input: &str) -> Option<String> {
        let lines = input
            .lines()
            .map(|l| scan!("{},{} -> {},{}" <- l).unwrap())
            .map(|(x1, y1, x2, y2)| ((x1, y1), (x2, y2)))
            .collect::<Vec<((usize, usize), (usize, usize))>>();

        let mut max_x = 0;
        let mut max_y = 0;
        for ((x1, y1), (x2, y2)) in lines.iter() {
            max_x = std::cmp::max(*x1, max_x);
            max_x = std::cmp::max(*x2, max_x);
            max_y = std::cmp::max(*y1, max_y);
            max_y = std::cmp::max(*y2, max_y);
        }
        let mut map = DMatrix::from_vec(max_x + 1, max_y + 1, vec![0; (max_x + 1) * (max_y + 1)]);
        for ((x1, y1), (x2, y2)) in lines.iter() {
            if x1 == x2 {
                if y2 > y1 {
                    for y in *y1..=(*y2) {
                        let i = map
                            .get_mut((*x1, y))
                            .expect(format!("Cannot index {:?}", (x1, y)).as_str());
                        *i += 1;
                    }
                } else {
                    for y in *y2..=(*y1) {
                        let i = map
                            .get_mut((*x1, y))
                            .expect(format!("Cannot index {:?}", (x1, y)).as_str());
                        *i += 1;
                    }
                }
            }
            if y1 == y2 {
                if x2 > x1 {
                    for x in *x1..=(*x2) {
                        let i = map
                            .get_mut((x, *y1))
                            .expect(format!("Cannot index {:?}", (x, y1)).as_str());
                        *i += 1;
                    }
                } else {
                    for x in *x2..=(*x1) {
                        let i = map
                            .get_mut((x, *y1))
                            .expect(format!("Cannot index {:?}", (x, y1)).as_str());
                        *i += 1;
                    }
                }
            }
        }
        Some((map.iter().filter(|v| **v > 1).count()).to_string())
    }

    fn part_two(&self, input: &str) -> Option<String> {
        let lines = input
            .lines()
            .map(|l| scan!("{},{} -> {},{}" <- l).unwrap())
            .map(|(x1, y1, x2, y2)| ((x1, y1), (x2, y2)))
            .collect::<Vec<((usize, usize), (usize, usize))>>();

        let mut max_x = 0;
        let mut max_y = 0;
        for ((x1, y1), (x2, y2)) in lines.iter() {
            max_x = std::cmp::max(*x1, max_x);
            max_x = std::cmp::max(*x2, max_x);
            max_y = std::cmp::max(*y1, max_y);
            max_y = std::cmp::max(*y2, max_y);
        }
        let mut map = DMatrix::from_vec(max_x + 1, max_y + 1, vec![0; (max_x + 1) * (max_y + 1)]);
        for ((x1, y1), (x2, y2)) in lines.iter() {
            if x1 == x2 {
                let (y1, y2) = if y1 > y2 { (y2, y1) } else { (y1, y2) };
                for y in *y1..=(*y2) {
                    let i = map
                        .get_mut((*x1, y))
                        .expect(format!("Cannot index {:?}", (x1, y)).as_str());
                    *i += 1;
                }
            } else if y1 == y2 {
                let (x1, x2) = if x1 > x2 { (x2, x1) } else { (x1, x2) };
                for x in *x1..=(*x2) {
                    let i = map
                        .get_mut((x, *y1))
                        .expect(format!("Cannot index {:?}", (x, y1)).as_str());
                    *i += 1;
                }
            } else if x2 > x1 && y2 > y1 {
                for (i, x) in (*x1..=(*x2)).enumerate() {
                    for (j, y) in (*y1..=(*y2)).enumerate() {
                        if i == j {
                            let m = map
                                .get_mut((x, y))
                                .expect(format!("Cannot index {:?}", (x, y)).as_str());
                            *m += 1;
                        }
                    }
                }
            } else if x2 > x1 && y1 > y2 {
                for (i, x) in (*x1..=(*x2)).enumerate() {
                    for (j, y) in (*y2..=(*y1)).rev().enumerate() {
                        if i == j {
                            let m = map
                                .get_mut((x, y))
                                .expect(format!("Cannot index {:?}", (x, y)).as_str());
                            *m += 1;
                        }
                    }
                }
            } else if x1 > x2 && y1 > y2 {
                for (i, x) in (*x2..=(*x1)).rev().enumerate() {
                    for (j, y) in (*y2..=(*y1)).rev().enumerate() {
                        if i == j {
                            let m = map
                                .get_mut((x, y))
                                .expect(format!("Cannot index {:?}", (x, y)).as_str());
                            *m += 1;
                        }
                    }
                }
            } else if x1 > x2 && y2 > y1 {
                for (i, x) in (*x2..=(*x1)).rev().enumerate() {
                    for (j, y) in (*y1..=(*y2)).enumerate() {
                        if i == j {
                            let m = map
                                .get_mut((x, y))
                                .expect(format!("Cannot index {:?}", (x, y)).as_str());
                            *m += 1;
                        }
                    }
                }
            }
        }
        Some((map.iter().filter(|v| **v >= 2).count()).to_string())
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
    let ans = prob.part_one(&input);
    dbg!(ans);
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
    let ans = prob.part_two(&input);
    dbg!(ans);
}
