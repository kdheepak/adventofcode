use std::{
  cmp::Ordering,
  collections::{BinaryHeap, HashMap, HashSet, VecDeque},
};

use ansi_term::Style;
use itertools::Itertools;

use crate::problem::Problem;

#[derive(Default)]
pub struct Day16 {}

impl Day16 {
}

#[derive(Default)]
struct Parser {
  input: Vec<u8>,
  pos: usize,
}

impl Parser {
  fn print(&self) {
    print!("{}", ansi_term::Color::Green.paint(&self.input[..self.pos].iter().join("")));
    print!("{}", &self.input[self.pos..].iter().join(""));
    println!();
    println!("{:>width$}", "^", width = self.pos + 1);
  }

  fn next(&mut self) -> u8 {
    let ans = self.input[self.pos];
    self.pos += 1;
    ans
  }

  fn convert_bytes(&self, bytes: &[u8]) -> usize {
    bytes.iter().rev().enumerate().fold(0, |acc, x| acc + *x.1 as usize * (2_usize).pow(x.0 as u32))
  }

  fn parse_version(&mut self) -> usize {
    let bytes = vec![self.next(), self.next(), self.next()];
    self.convert_bytes(&bytes)
  }

  fn parse_typeid(&mut self) -> usize {
    let bytes = vec![self.next(), self.next(), self.next()];
    self.convert_bytes(&bytes)
  }

  fn parse_literal_value(&mut self) -> usize {
    // println!("parsing literal value");
    // self.print();
    let start_count = self.pos;
    let mut group = self.next();
    let mut ans = vec![];
    while group == 1 {
      ans.push(self.next());
      ans.push(self.next());
      ans.push(self.next());
      ans.push(self.next());
      group = self.next();
    }
    ans.push(self.next());
    ans.push(self.next());
    ans.push(self.next());
    ans.push(self.next());
    let b = self.convert_bytes(&ans);
    // self.print();
    b
  }

  fn parse_operator_packets(&mut self) -> (usize, Vec<usize>) {
    let length_type_id = self.next();
    match length_type_id {
      0 => self.parse_operator_packets_type_0(),
      1 => self.parse_operator_packets_type_1(),
      _ => panic!("Unknown length type id"),
    }
  }

  fn parse_operator_packets_type_0(&mut self) -> (usize, Vec<usize>) {
    // println!("parsing operator packet type 0");
    // self.print();
    let length = {
      let bytes = vec![
        self.next(),
        self.next(),
        self.next(),
        self.next(),
        self.next(),
        self.next(),
        self.next(),
        self.next(),
        self.next(),
        self.next(),
        self.next(),
        self.next(),
        self.next(),
        self.next(),
        self.next(),
      ];
      self.convert_bytes(&bytes)
    };
    // self.print();
    let mut version_sum = 0;
    let mut values = vec![];
    let start_count = self.pos;
    loop {
      let (version, value) = self.parse_packet();
      version_sum += version;
      values.push(value);
      let end_count = self.pos;
      if end_count - start_count >= length {
        break;
      }
    }
    (version_sum, values)
  }

  fn parse_operator_packets_type_1(&mut self) -> (usize, Vec<usize>) {
    // println!("parsing operator packet type 1");
    // self.print();
    let length = {
      let bytes = vec![
        self.next(),
        self.next(),
        self.next(),
        self.next(),
        self.next(),
        self.next(),
        self.next(),
        self.next(),
        self.next(),
        self.next(),
        self.next(),
      ];
      self.convert_bytes(&bytes)
    };
    let mut version_sum = 0;
    let mut values = vec![];
    for i in 0..length {
      let (version, value) = self.parse_packet();
      version_sum += version;
      values.push(value);
    }
    (version_sum, values)
  }

  fn parse_packet(&mut self) -> (usize, usize) {
    let start_count = self.pos;
    let version = self.parse_version();
    // self.print();
    let typeid = self.parse_typeid();
    // self.print();
    match typeid {
      0 => {
        let (packet_version, value) = self.parse_operator_packets();
        (packet_version + version, value.iter().sum::<usize>())
      },
      1 => {
        let (packet_version, value) = self.parse_operator_packets();
        (packet_version + version, value.iter().product::<usize>())
      },
      2 => {
        let (packet_version, value) = self.parse_operator_packets();
        (packet_version + version, *value.iter().min().unwrap())
      },
      3 => {
        let (packet_version, value) = self.parse_operator_packets();
        (packet_version + version, *value.iter().max().unwrap())
      },
      4 => (version, self.parse_literal_value()),
      5 => {
        let (packet_version, value) = self.parse_operator_packets();
        let v = if value[0] > value[1] { 1 } else { 0 };
        (packet_version + version, v)
      },
      6 => {
        let (packet_version, value) = self.parse_operator_packets();
        let v = if value[0] < value[1] { 1 } else { 0 };
        (packet_version + version, v)
      },
      7 => {
        let (packet_version, value) = self.parse_operator_packets();
        let v = if value[0] == value[1] { 1 } else { 0 };
        (packet_version + version, v)
      },
      _ => panic!("Unexpected operator typeid"),
    }
  }
}

impl Problem for Day16 {
  fn part1(&self, input: &str) -> Option<String> {
    let input = input
      .chars()
      .map(|c| {
        match c {
          '0' => "0000".to_string(),
          '1' => "0001".to_string(),
          '2' => "0010".to_string(),
          '3' => "0011".to_string(),
          '4' => "0100".to_string(),
          '5' => "0101".to_string(),
          '6' => "0110".to_string(),
          '7' => "0111".to_string(),
          '8' => "1000".to_string(),
          '9' => "1001".to_string(),
          'A' => "1010".to_string(),
          'B' => "1011".to_string(),
          'C' => "1100".to_string(),
          'D' => "1101".to_string(),
          'E' => "1110".to_string(),
          'F' => "1111".to_string(),
          _ => panic!("unexpected string"),
        }
      })
      .collect::<Vec<String>>()
      .join("");
    let input = input.chars().map(|c| c.to_string().parse::<u8>().unwrap()).collect::<Vec<_>>();
    let mut p = Parser { input, pos: 0 };
    // p.print();
    let (v, _) = p.parse_packet();
    Some(v.to_string())
  }

  fn part2(&self, input: &str) -> Option<String> {
    let input = input
      .chars()
      .map(|c| {
        match c {
          '0' => "0000".to_string(),
          '1' => "0001".to_string(),
          '2' => "0010".to_string(),
          '3' => "0011".to_string(),
          '4' => "0100".to_string(),
          '5' => "0101".to_string(),
          '6' => "0110".to_string(),
          '7' => "0111".to_string(),
          '8' => "1000".to_string(),
          '9' => "1001".to_string(),
          'A' => "1010".to_string(),
          'B' => "1011".to_string(),
          'C' => "1100".to_string(),
          'D' => "1101".to_string(),
          'E' => "1110".to_string(),
          'F' => "1111".to_string(),
          _ => panic!("unexpected string"),
        }
      })
      .collect::<Vec<String>>()
      .join("");
    let input = input.chars().map(|c| c.to_string().parse::<u8>().unwrap()).collect::<Vec<_>>();
    let mut p = Parser { input, pos: 0 };
    let (_, v) = p.parse_packet();
    Some(v.to_string())
  }
}

#[cfg(test)]
mod tests {
  use indoc::indoc;

  use super::*;
  use crate::get_input;

  #[test]
  fn test_day16_part1() {
    let prob = Day16 {};

    let input = indoc! {"D2FE28"};
    assert_eq!(prob.part1(input), Some("6".to_string()));

    let input = indoc! {"38006F45291200"};
    assert_eq!(prob.part1(input), Some("9".to_string()));

    let input = indoc! {"EE00D40C823060"};
    assert_eq!(prob.part1(input), Some("14".to_string()));

    let input = indoc! {"8A004A801A8002F478"};
    assert_eq!(prob.part1(input), Some("16".to_string()));

    let input = indoc! {"620080001611562C8802118E34"};
    assert_eq!(prob.part1(input), Some("12".to_string()));

    let input = indoc! {"C0015000016115A2E0802F182340"};
    assert_eq!(prob.part1(input), Some("23".to_string()));

    let input = indoc! {"A0016C880162017C3686B18A3D4780"};
    assert_eq!(prob.part1(input), Some("31".to_string()));

    assert_eq!(prob.part1(&get_input(16)), Some("852".to_string()));
  }

  #[test]
  fn test_day16_part2() {
    let prob = Day16 {};
    let input = indoc! {"C200B40A82"};
    assert_eq!(prob.part2(input), Some("3".to_string()));

    let input = indoc! {"04005AC33890"};
    assert_eq!(prob.part2(input), Some("54".to_string()));

    let input = indoc! {"880086C3E88112"};
    assert_eq!(prob.part2(input), Some("7".to_string()));

    let input = indoc! {"CE00C43D881120"};
    assert_eq!(prob.part2(input), Some("9".to_string()));

    let input = indoc! {"D8005AC2A8F0"};
    assert_eq!(prob.part2(input), Some("1".to_string()));

    let input = indoc! {"F600BC2D8F"};
    assert_eq!(prob.part2(input), Some("0".to_string()));

    let input = indoc! {"9C005AC2F8F0"};
    assert_eq!(prob.part2(input), Some("0".to_string()));

    let input = indoc! {"9C0141080250320F1802104A08"};
    assert_eq!(prob.part2(input), Some("1".to_string()));

    assert_eq!(prob.part2(&get_input(16)), Some("19348959966392".to_string()));
  }
}
