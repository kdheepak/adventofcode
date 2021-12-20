#![allow(dead_code)]
#![allow(unused_imports)]
#![allow(unused_variables)]
#![allow(unused_must_use)]

extern crate lazy_static;

pub mod event;

pub mod day01;
pub mod day02;
pub mod day03;
pub mod day04;
pub mod day05;
pub mod day06;
pub mod day07;
pub mod day08;
pub mod day09;
pub mod day10;
pub mod day11;
pub mod day12;
pub mod day13;
pub mod day14;
pub mod day15;
pub mod day16;
pub mod day17;
pub mod day18;
pub mod day20;

pub mod problem;

use std::{fs, path::PathBuf, time::Instant};

use anyhow::{anyhow, Context, Result};
use problem::Problem;

fn make_client() -> reqwest::blocking::Client {
  let mut headers = reqwest::header::HeaderMap::default();
  let cookie = reqwest::header::HeaderValue::from_str(
    format!("session={}", std::env::var("ADVENTOFCODE_SESSION").expect("Unable to get advent of code session token"))
      .as_str(),
  )
  .unwrap();
  headers.insert("Cookie", cookie);
  reqwest::blocking::Client::builder().default_headers(headers).build().unwrap()
}

pub fn download_input(day: usize) -> Result<String> {
  let client = make_client();
  let url = format!("https://adventofcode.com/2021/day/{}/input", day);
  let resp = client.get(url.as_str()).send()?;
  if resp.status().is_success() {
    Ok(resp.text()?)
  } else {
    Err(anyhow!(resp.text()?))
  }
}

pub fn visualize_problem(day: usize) {
  let input = get_input(day);
  let problem = get_problem(day).expect("Unable to create problem.");
  problem.visualize(&input);
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
  let input: PathBuf = [env!("CARGO_MANIFEST_DIR"), format!("inputs/day{:02}.txt", day).as_str()].iter().collect();

  if !input.exists() {
    let s = download_input(day).with_context(|| format!("Unable to download input for day {:02}.", day)).unwrap();
    fs::write(&input, s).expect("Unable to write inputs to file");
  }

  fs::read_to_string(input).expect("Unable to read inputs").trim_start().trim_end().to_string()
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
    6 => Some(Box::new(day06::Day06::default())),
    7 => Some(Box::new(day07::Day07::default())),
    8 => Some(Box::new(day08::Day08::default())),
    9 => Some(Box::new(day09::Day09::default())),
    10 => Some(Box::new(day10::Day10::default())),
    11 => Some(Box::new(day11::Day11::default())),
    12 => Some(Box::new(day12::Day12::default())),
    13 => Some(Box::new(day13::Day13::default())),
    14 => Some(Box::new(day14::Day14::default())),
    15 => Some(Box::new(day15::Day15::default())),
    16 => Some(Box::new(day16::Day16::default())),
    17 => Some(Box::new(day17::Day17::default())),
    18 => Some(Box::new(day18::Day18::default())),
    20 => Some(Box::new(day20::Day20::default())),
    _ => None,
  }
}
