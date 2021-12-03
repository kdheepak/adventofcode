use crate::problem::Problem;

#[derive(Default)]
pub struct DayThree {}

fn has_most_common_bit(bits: &[usize], bit: usize) -> bool {
    let mut total = [0, 0];
    for item in bits {
        total[(item >> bit) & 1] += 1;
    }
    total[1] >= total[0]
}

fn helper(input: &str, is_oxygen: bool) -> usize {
    let n = input.lines().next().unwrap().chars().count();
    let mut bits = input.lines().map(|item| usize::from_str_radix(item, 2).unwrap()).collect::<Vec<_>>();
    for i in (0..n).rev() {
        let keep = if is_oxygen {
            has_most_common_bit(&bits, i) as usize
        } else {
            !has_most_common_bit(&bits, i) as usize
        };
        bits.retain(|item| ((item >> i) & 1) == keep);
        if bits.len() == 1 {
            break;
        }
    }

    bits[0]
}

impl Problem for DayThree {
    fn part_one(&self, input: &str) -> Option<String> {
        let n = input.lines().next().unwrap().chars().count();
        let bits = input.lines().map(|item| usize::from_str_radix(item, 2).unwrap()).collect::<Vec<_>>();

        let gamma: usize = (0..n).rev().map(|i| (has_most_common_bit(&bits, i) as usize) << i).sum();
        let base: u32 = 2;
        let epsilon = (!gamma) & (base.pow(n as u32) as usize - 1);
        Some((gamma * epsilon).to_string())
    }

    fn part_two(&self, input: &str) -> Option<String> {
        let oxygen = helper(input, true);
        let co2 = helper(input, false);
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
