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
                        .min_values(0),
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
        Some(("download", matches)) => {
            match matches.value_of("day") {
                Some(d) => {
                    let d = d.parse::<_>().expect("Unable to parse input day");
                    get_input(d);
                    println!("Successfully downloaded input for day {}", d);
                }
                None => {
                    panic!("Expected valid day command line input");
                }
            };
        }
        Some(("solve", matches)) => {
            match matches.value_of("day") {
                Some(d) => solve_problem(
                    d.parse::<_>().expect("Unable to parse input day"),
                    matches.value_of("part"),
                )?,
                None => {
                    panic!("Expected valid day command line input");
                }
            };
        }
        None => {}
        _ => {}
    }

    Ok(())
}

fn download_input(day: usize) -> Result<String> {
    let client = reqwest::blocking::Client::new();
    let url = format!("https://adventofcode.com/2021/day/{}/input", day);
    let cookie = format!("session={}", env!("ADVENTOFCODE_SESSION"));
    let resp = client
        .get(url.as_str())
        .header(reqwest::header::COOKIE, cookie)
        .send()?;
    Ok(resp.text()?)
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

fn solve_problem(day: usize, part: Option<&str>) -> Result<()> {
    let input = get_input(day);
    let problem = get_problem(day).expect("Unable to create problem.");

    match part {
        Some("1") => {
            println!("Part 1: {}", problem.part_one(&input).unwrap());
        }
        Some("2") => {
            println!("Part 2: {}", problem.part_two(&input).unwrap());
        }
        _ => {
            println!("Part 1: {}", problem.part_one(&input).unwrap());
            println!("Part 2: {}", problem.part_two(&input).unwrap());
        }
    };

    Ok(())
}

fn get_problem(day: usize) -> Option<Box<dyn Problem>> {
    match day {
        1 => Some(Box::new(DayOne::default())),
        _ => None,
    }
}
