use crate::problem::Problem;

#[derive(Default)]
pub struct DayOne {}

impl Problem for DayOne {
    fn part_one(&self, input: &str) -> Option<String> {
        let ans = input
            .split_whitespace()
            .map(|line| line.parse::<usize>().unwrap())
            .collect::<Vec<usize>>()
            .windows(2)
            .filter(|e| e[1] > e[0])
            .count();
        Some(ans.to_string())
    }

    fn part_two(&self, input: &str) -> Option<String> {
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
