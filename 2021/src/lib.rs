pub mod day01;
pub mod day02;
pub mod day03;
pub mod day04;
pub mod day05;

pub mod problem;

use problem::Problem;

use std::time::Instant;

use anyhow::{anyhow, Result};
use std::fs;
use std::path::PathBuf;

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
    let html = client.post(url).form(&params).send()?.text()?;
    let plaintext = html2text::from_read(std::io::BufReader::new(html.as_bytes()), 80);
    Ok(plaintext)
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
        1 => Ok(problem.part1(&input).unwrap()),
        2 => Ok(problem.part2(&input).unwrap()),
        _ => Err(anyhow!("Unable to solve for part {}", part)),
    }
}

pub fn benchmark_problem(days: Vec<usize>) {
    for day in days {
        println!("Day {:02}:", day);
        let input = get_input(day);
        let problem = get_problem(day).expect("Unable to create problem.");
        let now = Instant::now();
        let answer = problem.part1(&input).unwrap();
        let elapsed = now.elapsed();
        println!("    Part 1 [{:09.2?}]: {}", elapsed, answer);
        let now = Instant::now();
        let answer = problem.part2(&input).unwrap();
        let elapsed = now.elapsed();
        println!("    Part 2 [{:09.2?}]: {}", elapsed, answer);
    }
}

pub fn get_problem(day: usize) -> Option<Box<dyn Problem>> {
    match day {
        1 => Some(Box::new(day01::Day01::default())),
        2 => Some(Box::new(day02::Day02::default())),
        3 => Some(Box::new(day03::Day03::default())),
        4 => Some(Box::new(day04::Day04::default())),
        5 => Some(Box::new(day05::Day05::default())),
        _ => None,
    }
}
