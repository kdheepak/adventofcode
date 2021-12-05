use aoc2021::*;
use criterion::{black_box, criterion_group, criterion_main, Criterion};

fn criterion_benchmark(c: &mut Criterion) {
    for day in &[1, 2, 3, 4, 5] {
        let input = get_input(*day);
        let problem = get_problem(*day).expect("Unable to create problem.");
        c.bench_function(format!("Day {:02} part 1", day).as_str(), |b| {
            b.iter(|| problem.part1(black_box(&input)).unwrap())
        });
        c.bench_function(format!("Day {:02} part 2", day).as_str(), |b| {
            b.iter(|| problem.part2(black_box(&input)).unwrap())
        });
    }
}

criterion_group!(benches, criterion_benchmark);
criterion_main!(benches);
