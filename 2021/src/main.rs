#![allow(dead_code)]
#![allow(unused_imports)]
#![allow(unused_variables)]

use anyhow::{anyhow, Result};
use aoc2021::*;
use clap::{crate_authors, crate_description, crate_license, crate_name, crate_version, App, Arg};

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
            App::new("benchmark").arg(
                Arg::new("days")
                    .short('d')
                    .long("days")
                    .takes_value(true)
                    .multiple_values(true),
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
            let text = submit_solution(day, part, answer)?;
            println!("{}", text);
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
        Some(("benchmark", matches)) => {
            let days = matches
                .values_of("days")
                .expect("Expected valid day command line input")
                .map(|x| x.parse::<_>().expect("Unable to parse input day"))
                .collect();
            benchmark_problem(days);
        }
        _ => {}
    }
    Ok(())
}
