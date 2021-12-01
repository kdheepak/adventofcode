#![allow(dead_code)]
#![allow(unused_imports)]
#![allow(unused_variables)]

use anyhow::{anyhow, Result};
use clap::{crate_authors, crate_description, crate_license, crate_name, crate_version, App, Arg};

use std::fs;
use std::path::{Path, PathBuf};

use aoc2021::day01::DayOne;

use aoc2021::problem::Problem;

pub fn generate_cli_app() -> App<'static> {
    let app = App::new(crate_name!())
        .version(crate_version!())
        .author(crate_authors!("\n"))
        .about(crate_description!())
        .license(crate_license!())
        .subcommand(
            App::new("submit")
                .arg(
                    Arg::new("day")
                        .short('d')
                        .long("day")
                        .takes_value(true)
                        .multiple_values(false)
                        .max_values(1)
                        .min_values(1),
                )
                .arg(
                    Arg::new("part")
                        .short('p')
                        .long("part")
                        .takes_value(true)
                        .multiple_values(true)
                        .max_values(1)
                        .min_values(1),
                ),
        )
        .subcommand(
            App::new("solve")
                .arg(
                    Arg::new("day")
                        .short('d')
                        .long("day")
                        .takes_value(true)
                        .multiple_values(false),
                )
                .arg(
                    Arg::new("part")
                        .short('p')
                        .long("part")
                        .takes_value(true)
                        .multiple_values(true)
                        .max_values(1)
                        .min_values(1),
                ),
        )
        .subcommand(
            App::new("download").arg(
                Arg::new("day")
                    .short('d')
                    .long("day")
                    .takes_value(true)
                    .multiple_values(false),
            ),
        );
    app
}

fn main() -> Result<()> {
    let app = generate_cli_app();
    let matches = app.get_matches();
    match matches.subcommand() {
        Some(("submit", matches)) => {
            let day = matches
                .value_of("day")
                .expect("Expected valid day command line input")
                .parse::<_>()
                .expect("Unable to parse input day");
            let part = matches
                .value_of("part")
                .expect("Expected valid day command line input")
                .parse::<_>()
                .expect("Unable to parse input part");
            let answer = solve_problem(day, part)?;
            submit_solution(day, part, answer)?;
            println!(
                "Successfully submitted solution for day {} part {}",
                day, part
            );
        }
        Some(("download", matches)) => {
            let day = matches
                .value_of("day")
                .expect("Expected valid day command line input")
                .parse::<_>()
                .expect("Unable to parse input day");
            get_input(day);
            println!("Successfully downloaded input for day {}", day);
        }
        Some(("solve", matches)) => {
            let day = matches
                .value_of("day")
                .expect("Expected valid day command line input")
                .parse::<_>()
                .expect("Unable to parse input day");
            let part = matches
                .value_of("part")
                .expect("Expected valid day command line input")
                .parse::<_>()
                .expect("Unable to parse input part");
            let answer = solve_problem(day, part)?;
            println!("Day {:02} Part {} : {}", day, part, answer);
        }
        _ => {}
    }
    Ok(())
}

fn download_input(day: usize) -> Result<String> {
    let client = make_client();
    let url = format!("https://adventofcode.com/2021/day/{}/input", day);
    let resp = client.get(url.as_str()).send()?;
    Ok(resp.text()?)
}

fn submit_solution(day: usize, level: usize, answer: String) -> Result<String> {
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

fn get_input(day: usize) -> String {
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

fn solve_problem(day: usize, part: usize) -> Result<String> {
    let input = get_input(day);
    let problem = get_problem(day).expect("Unable to create problem.");

    match part {
        1 => Ok(problem.part_one(&input).unwrap()),
        2 => Ok(problem.part_two(&input).unwrap()),
        _ => Err(anyhow!("Unable to solve for part {}", part)),
    }
}

fn get_problem(day: usize) -> Option<Box<dyn Problem>> {
    match day {
        1 => Some(Box::new(DayOne::default())),
        _ => None,
    }
}
