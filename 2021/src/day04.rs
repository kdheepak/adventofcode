use crate::problem::Problem;

#[derive(Default)]
pub struct Day04 {}

use nalgebra::Matrix5;

#[derive(Debug, Copy, Clone)]
struct Board(Matrix5<(usize, bool)>);

impl Board {
    fn is_bingo(&self) -> bool {
        for s in 0..5 {
            if self.0.row(s).iter().all(|x| x.1) {
                return true;
            }
            if self.0.column(s).iter().all(|x| x.1) {
                return true;
            }
        }
        false
    }

    fn update(&mut self, draw: usize) {
        if let Some(i) = self.0.iter().position(|x| x.0 == draw) {
            self.0[i] = (draw, true)
        }
    }

    fn calculate_score(&self, draw: usize) -> usize {
        let s = self.0.iter().filter(|x| !x.1).map(|x| x.0).sum::<usize>();
        s * draw
    }
}

fn parse_input(input: &str) -> (Vec<usize>, Vec<Board>) {
    let mut s = input.split("\n\n");
    let draws = s
        .next()
        .unwrap()
        .split(',')
        .filter(|n| !n.is_empty())
        .map(|n| n.parse::<usize>().unwrap())
        .collect::<Vec<usize>>();
    let boards = s
        .map(|b| Board {
            0: Matrix5::from_iterator(b.lines().flat_map(|l| {
                l.split_whitespace()
                    .filter_map(|i| i.parse::<usize>().ok())
                    .map(|x| (x, false))
            })),
        })
        .collect();
    (draws, boards)
}

impl Problem for Day04 {
    fn part_one(&self, input: &str) -> Option<String> {
        let (draws, mut boards) = parse_input(input);

        for draw in draws {
            for board in boards.iter_mut() {
                board.update(draw);
                if board.is_bingo() {
                    return Some(board.calculate_score(draw).to_string());
                }
            }
        }
        unreachable!()
    }

    fn part_two(&self, input: &str) -> Option<String> {
        let (draws, mut boards) = parse_input(input);
        let mut won_boards = vec![false; boards.len()];
        for draw in draws {
            for (i, board) in boards.iter_mut().enumerate() {
                if won_boards[i] {
                    continue;
                }
                board.update(draw);
                if board.is_bingo() {
                    won_boards[i] = true;
                    if won_boards.iter().all(|x| *x) {
                        return Some(board.calculate_score(draw).to_string());
                    }
                }
            }
        }
        unreachable!()
    }
}

#[test]
fn test_day04_part1() {
    let input = r#"7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7"#;
    let prob = Day04 {};
    dbg!(prob.part_one(&input));
}
