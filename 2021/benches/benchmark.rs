use aoc2021::*;
use criterion::{criterion_group, criterion_main, Criterion};

fn criterion_benchmark(c: &mut Criterion) {
  for day in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13].iter().rev() {
    let input = get_input(*day);
    let problem = get_problem(*day).expect("Unable to create problem.");
    c.bench_function(format!("Day {:02} part 1", day).as_str(), |b| b.iter(|| problem.part1(&input).unwrap()));
    c.bench_function(format!("Day {:02} part 2", day).as_str(), |b| b.iter(|| problem.part2(&input).unwrap()));
  }
}

criterion_group!(benches, criterion_benchmark);
criterion_main!(benches);
