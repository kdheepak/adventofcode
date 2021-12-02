use crate::problem::Problem;

#[derive(Default)]
pub struct DayTwo {}

impl Problem for DayTwo {
    fn part_one(&self, input: &str) -> Option<String> {
        let lines = input.lines();

        let mut depth = 0;
        let mut position = 0;

        for line in lines {
            let s: Vec<&str> = line.split(' ').collect();
            let dir = s[0];
            let mag = s[1];
            match dir {
                "forward" => {
                    position += mag.parse::<usize>().unwrap();
                }
                "down" => {
                    depth += mag.parse::<usize>().unwrap();
                }
                "up" => {
                    depth -= mag.parse::<usize>().unwrap();
                }
                _ => {
                    panic!("unknown dir")
                }
            }
        }
        Some((depth * position).to_string())
    }

    fn part_two(&self, input: &str) -> Option<String> {
        let lines = input.lines();

        let mut depth = 0;
        let mut position = 0;
        let mut aim = 0;

        for line in lines {
            let s: Vec<&str> = line.split(' ').collect();
            let dir = s[0];
            let mag = s[1];
            match dir {
                "forward" => {
                    position += mag.parse::<usize>().unwrap();
                    depth += aim * mag.parse::<usize>().unwrap();
                }
                "down" => {
                    aim += mag.parse::<usize>().unwrap();
                }
                "up" => {
                    aim -= mag.parse::<usize>().unwrap();
                }
                _ => {
                    panic!("unknown dir")
                }
            }
        }
        Some((depth * position).to_string())
    }
}
