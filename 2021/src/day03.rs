use crate::problem::Problem;

#[derive(Default)]
pub struct DayThree {}

fn has_most_common_bit(bits: &Vec<Vec<usize>>, bit: usize) -> bool {
    let mut total = [0, 0];
    for item in bits {
        if item[bit] == 1 {
            total[0] += 1
        } else {
            total[1] += 1
        }
    }
    total[0] >= total[1]
}

impl Problem for DayThree {
    fn part_one(&self, input: &str) -> Option<String> {
        let n = input.lines().next().unwrap().chars().count();
        let mut lines = vec![0; n];
        for line in input.lines() {
            let bits = line
                .chars()
                .map(|c| c.to_string().parse::<usize>().unwrap())
                .collect::<Vec<usize>>();
            for (i, b) in bits.iter().enumerate() {
                lines[i] += b;
            }
        }

        let mut gamma = 0;
        let mut epsilon = 0;

        let base: i32 = 2;
        for (i, b) in lines.iter().rev().enumerate() {
            if *b > (input.lines().count() / 2) {
                gamma += base.pow(i as u32);
            } else {
                epsilon += base.pow(i as u32);
            }
        }

        Some((gamma * epsilon).to_string())
    }

    fn part_two(&self, input: &str) -> Option<String> {
        let n = input.lines().next().unwrap().chars().count();

        let mut bits = vec![];
        for line in input.lines() {
            bits.push(
                line.chars()
                    .map(|c| c.to_string().parse::<usize>().unwrap())
                    .collect::<Vec<usize>>(),
            );
        }

        for i in 0..n {
            let keep = has_most_common_bit(&bits, i) as usize;
            bits.retain(|item| item[i] == keep);
            if bits.len() == 1 {
                break;
            }
        }

        let mut oxygen = 0;
        let base: u32 = 2;
        for (i, b) in bits[0].iter().rev().enumerate() {
            if *b == 1 {
                oxygen += base.pow(i as u32)
            }
        }

        dbg!(oxygen);

        let mut bits = vec![];
        for line in input.lines() {
            bits.push(
                line.chars()
                    .map(|c| c.to_string().parse::<usize>().unwrap())
                    .collect::<Vec<usize>>(),
            );
        }

        for i in 0..n {
            let keep = has_most_common_bit(&bits, i) as usize;
            bits.retain(|item| item[i] != keep);
            if bits.len() == 1 {
                break;
            }
        }
        let mut co2 = 0;
        let base: u32 = 2;
        for (i, b) in bits[0].iter().rev().enumerate() {
            if *b == 1 {
                co2 += base.pow(i as u32)
            }
        }

        dbg!(co2);

        Some((oxygen * co2).to_string())
    }
}

#[test]
fn test_day_three_part_one() {
    let prob = DayThree {};
    let ans = prob.part_one(
        r#"00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010"#,
    );
    dbg!(ans);
}

#[test]
fn test_day_three_part_two() {
    let prob = DayThree {};
    let ans = prob.part_two(
        r#"00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010"#,
    );
    dbg!(ans);
}
