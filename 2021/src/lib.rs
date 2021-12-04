pub mod day01;
pub mod day02;
pub mod day03;
pub mod day04;

pub mod problem;

use day01::DayOne;
use day02::DayTwo;
use day03::DayThree;
use day04::Day04;

use problem::Problem;

use std::time::Instant;

use std::fs;
use std::path::PathBuf;
use anyhow::{anyhow, Result};

fn make_client() -> reqwest::blocking::Client {
    let mut headers = reqwest::header::HeaderMap::default();
    let cookie = reqwest::header::HeaderValue::from_str(
        format!("session={}", env!("ADVENTOFCODE_SESSION")).as_str(),
    )
    .unwrap();
    headers.insert("Cookie", cookie);
    reqwest::blocking::Client::builder()
        .default_headers(headers)
        .build()
        .unwrap()
}

pub fn download_input(day: usize) -> Result<String> {
    let client = make_client();
    let url = format!("https://adventofcode.com/2021/day/{}/input", day);
    let resp = client.get(url.as_str()).send()?;
    Ok(resp.text()?)
}

pub fn submit_solution(day: usize, level: usize, answer: String) -> Result<String> {
    let client = make_client();
    let url = format!("https://adventofcode.com/2021/day/{}/answer", day);
    let mut params = std::collections::HashMap::new();
    params.insert("level", level.to_string());
    params.insert("answer", answer);
    dbg!(&params);
    let resp = client.post(url).form(&params).send()?;
    dbg!(&resp);
    Ok(resp.text()?)
}

pub fn get_input(day: usize) -> String {
    let input: PathBuf = [
        env!("CARGO_MANIFEST_DIR"),
        format!("inputs/day{:02}.txt", day).as_str(),
    ]
    .iter()
    .collect();

    if !input.exists() {
        let s = download_input(day).unwrap();
        fs::write(&input, s).expect("Unable to write inputs to file");
    }

    fs::read_to_string(input).expect("Unable to read inputs")
}

pub fn solve_problem(day: usize, part: usize) -> Result<String> {
    let input = get_input(day);
    let problem = get_problem(day).expect("Unable to create problem.");

    match part {
        1 => Ok(problem.part_one(&input).unwrap()),
        2 => Ok(problem.part_two(&input).unwrap()),
        _ => Err(anyhow!("Unable to solve for part {}", part)),
    }
}

pub fn benchmark_problem(days: Vec<usize>) {
    for day in days {
        println!("Day {:02}:", day);
        let input = get_input(day);
        let problem = get_problem(day).expect("Unable to create problem.");
        let now = Instant::now();
        let answer = problem.part_one(&input).unwrap();
        let elapsed = now.elapsed();
        println!("    Part 1 [{:08.2?}]: {}", elapsed, answer);
        let now = Instant::now();
        let answer = problem.part_two(&input).unwrap();
        let elapsed = now.elapsed();
        println!("    Part 2 [{:08.2?}]: {}", elapsed, answer);
    }
}

pub fn get_problem(day: usize) -> Option<Box<dyn Problem>> {
    match day {
        1 => Some(Box::new(DayOne::default())),
        2 => Some(Box::new(DayTwo::default())),
        3 => Some(Box::new(DayThree::default())),
        4 => Some(Box::new(Day04::default())),
        _ => None,
    }
}
