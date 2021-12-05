use crate::problem::Problem;

#[derive(Default)]
pub struct Day01 {}

impl Problem for Day01 {
    fn part1(&self, input: &str) -> Option<String> {
        let ans = input
            .split_whitespace()
            .map(|line| line.parse::<usize>().unwrap())
            .collect::<Vec<usize>>()
            .windows(2)
            .filter(|e| e[1] > e[0])
            .count();
        Some(ans.to_string())
    }

    fn part2(&self, input: &str) -> Option<String> {
        let ans = input
            .split_whitespace()
            .map(|line| line.parse::<usize>().unwrap())
            .collect::<Vec<usize>>()
            .windows(4)
            .filter(|e| e[3] > e[0])
            .count();
        Some(ans.to_string())
    }
}
