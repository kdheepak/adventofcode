#![allow(dead_code)]
#![allow(unused_imports)]
#![allow(unused_variables)]

use anyhow::{anyhow, Result};
use clap::{crate_authors, crate_description, crate_license, crate_name, crate_version, App, Arg};

use std::fs;
use std::path::PathBuf;

use aoc2021::day01::DayOne;

use aoc2021::problem::Problem;

pub fn generate_cli_app() -> App<'static> {
    let app = App::new(crate_name!())
        .version(crate_version!())
        .author(crate_authors!("\n"))
        .about(crate_description!())
        .license(crate_license!())
        .arg("-d..., --debug... 'Turn debugging information on'")
        .arg("--part=<NUMBER> 'Part of day'")
        .arg(
            Arg::new("day")
                .about("Day")
                .index(1)
                .required(true)
                .multiple_values(false)
                .takes_value(true),
        );
    app
}

fn main() -> Result<()> {
    let app = generate_cli_app();
    let matches = app.get_matches();

    match matches.value_of("day") {
        Some(d) => solve_problem(
            d.parse::<_>().expect("Unable to parse input day"),
            matches.value_of("part"),
        )?,
        None => {
            panic!("Expected valid day command line input");
        }
    };

    Ok(())
}

fn get_input(day: usize) -> String {
    let input: PathBuf = [
        env!("CARGO_MANIFEST_DIR"),
        format!("inputs/day{:02}.txt", day).as_str(),
    ]
    .iter()
    .collect();

    fs::read_to_string(input).unwrap()
}

fn solve_problem(day: usize, part: Option<&str>) -> Result<()> {
    let input = get_input(day);
    let problem = get_problem(day).expect("Unable to create problem.");

    match part {
        Some("1") => {
            dbg!(problem.part_one(&input).unwrap());
        }
        Some("2") => {
            dbg!(problem.part_two(&input).unwrap());
        }
        _ => {
            dbg!(problem.part_one(&input).unwrap());
            dbg!(problem.part_two(&input).unwrap());
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
