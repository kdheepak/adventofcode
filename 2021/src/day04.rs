use crate::problem::Problem;

#[derive(Default)]
pub struct Day04 {}

fn check_selected(selected: &[(usize, usize, usize)], last: (usize, usize, usize, usize)) -> bool {
    let (board, row, col, _) = last;

    let mut bingo = vec![];
    let rem = row % 5;
    for r in (row - rem)..(row - rem + 5) {
        bingo.push(selected.contains(&(board, r, col)))
    }
    if bingo.iter().all(|x| *x) {
        return true;
    }
    let mut bingo = vec![];
    let rem = col % 5;
    for c in (col - rem)..(col - rem + 5) {
        bingo.push(selected.contains(&(board, row, c)))
    }
    if bingo.iter().all(|x| *x) {
        return true;
    }

    false
}

fn calculate_score(
    board: &[Vec<usize>],
    selected: &[(usize, usize, usize)],
    board_number: usize,
) -> usize {
    let mut board = board.to_owned();
    for (board_id, row, col) in selected {
        if *board_id == board_number {
            board[*row][*col] = 0;
        }
    }
    let mut total = 0;
    for row in board {
        total += row.iter().sum::<usize>();
    }
    total
}

impl Problem for Day04 {
    fn part_one(&self, input: &str) -> Option<String> {
        let mut lines = input.lines();
        let sequence = lines
            .next()
            .unwrap()
            .split(',')
            .filter(|n| !n.is_empty())
            .map(|n| n.parse::<usize>().unwrap())
            .collect::<Vec<usize>>();

        lines.next().unwrap();
        let mut boards = vec![];
        let mut board = vec![];
        for line in lines {
            if line.is_empty() {
                boards.push(board);
                board = vec![];
            } else {
                board.push(
                    line.split(' ')
                        .filter(|n| !n.is_empty())
                        .map(|n| n.parse::<usize>().unwrap())
                        .collect::<Vec<usize>>(),
                );
            }
        }
        boards.push(board);

        let mut selected = vec![];
        for s in sequence.iter() {
            for (board_number, board) in boards.iter().enumerate() {
                for (row_number, row) in board.iter().enumerate() {
                    for (col_number, val) in row.iter().enumerate() {
                        if val == s {
                            selected.push((board_number, row_number, col_number));
                            if check_selected(&selected, (board_number, row_number, col_number, *s))
                            {
                                dbg!("bingo");
                                let s =
                                    calculate_score(&boards[board_number], &selected, board_number);
                                return Some((s * *val).to_string());
                            }
                        }
                    }
                }
            }
        }

        None
    }

    fn part_two(&self, input: &str) -> Option<String> {
        let mut lines = input.lines();
        let sequence = lines
            .next()
            .unwrap()
            .split(',')
            .filter(|n| !n.is_empty())
            .map(|n| n.parse::<usize>().unwrap())
            .collect::<Vec<usize>>();

        lines.next().unwrap();
        let mut boards = vec![];
        let mut board = vec![];
        for line in lines {
            if line.is_empty() {
                boards.push(board);
                board = vec![];
            } else {
                board.push(
                    line.split(' ')
                        .filter(|n| !n.is_empty())
                        .map(|n| n.parse::<usize>().unwrap())
                        .collect::<Vec<usize>>(),
                );
            }
        }
        boards.push(board);

        let mut selected = vec![];
        let mut skip_boards = vec![];
        let mut last_called = 0;
        for s in sequence.iter() {
            for (board_number, board) in boards.iter().enumerate() {
                if skip_boards.contains(&board_number) {
                    continue;
                }
                for (row_number, row) in board.iter().enumerate() {
                    for (col_number, val) in row.iter().enumerate() {
                        if val == s {
                            selected.push((board_number, row_number, col_number));
                            if check_selected(&selected, (board_number, row_number, col_number, *s))
                            {
                                dbg!("bingo");
                                skip_boards.push(board_number);
                                last_called = *s;
                            }
                        }
                    }
                }
            }
        }
        let board_number = skip_boards.last().unwrap();
        let s = calculate_score(&boards[*board_number], &selected, *board_number);
        Some((s * last_called).to_string())
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
