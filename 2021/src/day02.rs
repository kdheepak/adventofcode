use crate::problem::Problem;

#[derive(Default)]
pub struct DayTwo {}

impl Problem for DayTwo {
    fn part_one(&self, input: &str) -> Option<String> {
        let lines = input
            .lines()
            .map(|line| line.split_once(' ').unwrap())
            .map(|(dir, mag)| (dir, mag.parse::<usize>().unwrap()));
        let mut depth = 0;
        let mut position = 0;
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
        let lines = input
            .lines()
            .map(|line| line.split_once(' ').unwrap())
            .map(|(dir, mag)| (dir, mag.parse::<usize>().unwrap()));
        let mut depth = 0;
        let mut position = 0;
        let mut aim = 0;
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
