use crate::problem::Problem;
use serde_scan::scan;

#[derive(Default)]
pub struct Day02 {}

impl Problem for Day02 {
    fn part_one(&self, input: &str) -> Option<String> {
        let lines: Vec<(&str, usize)> = input
            .lines()
            .map(|line| scan!("{} {}" <- line).unwrap())
            .collect();
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

    fn part_two(&self, input: &str) -> Option<String> {
        let lines: Vec<(&str, usize)> = input
            .lines()
            .map(|line| scan!("{} {}" <- line).unwrap())
            .collect();
        let (mut depth, mut position, mut aim) = (0, 0, 0);
        for (dir, mag) in lines {
            match dir {
                "forward" => {
                    position += mag;
                    depth += aim * mag;
                }
                "down" => aim += mag,
                "up" => aim -= mag,
                _ => panic!("unknown dir {}", dir),
            }
        }
        Some((depth * position).to_string())
    }
}
