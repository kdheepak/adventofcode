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
  version_sum: usize,
}

impl Parser {
  fn peek(&self) -> Option<u8> {
    self.input.get(self.pos).cloned()
  }

  fn next(&mut self) -> u8 {
    self.pos += 1;
    self.input[self.pos - 1]
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

  fn parse_literal_value(&mut self) -> (usize, usize) {
    let start_count = self.pos;
    let mut group = self.next();
    dbg!(group);
    let mut ans = vec![];
    while group == 1 {
      let bytes = vec![self.next(), self.next(), self.next(), self.next()];
      let b = self.convert_bytes(&bytes);
      ans.push(b);
      group = self.next();
    }
    let bytes = vec![self.next(), self.next(), self.next(), self.next()];
    let b = self.convert_bytes(&bytes);
    ans.push(b);
    self.pos += (self.pos - start_count - 1) % 4;
    let end_count = self.pos;
    (ans.iter().map(|b| b.to_string()).join("").parse::<usize>().unwrap(), end_count - start_count)
  }

  fn parse_operator_packets(&mut self) -> usize {
    dbg!("inside operator packets");
    let mode = self.next();
    let length_type_id = match mode {
      0 => {
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
      },
      1 => {
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
      },
      _ => panic!("Unknown operator bit"),
    };
    dbg!(mode, length_type_id);
    if mode == 0 {
      let mut count = 0;
      while count < length_type_id {
        println!(
          "Creating nested parser for mode 0 with input {}",
          self.input[self.pos..self.pos + length_type_id - count].iter().join("")
        );
        let mut p = Parser {
          input: self.input[self.pos..self.pos + (length_type_id - count)].to_owned(),
          pos: 0,
          version_sum: 0,
        };
        let c = p.parse_packet();
        self.version_sum += p.version_sum;
        println!("Finished parsing with version_sum = {}", self.version_sum);
        count += c;
        self.pos += c;
        dbg!((count, length_type_id, count < length_type_id));
      }
    } else if mode == 1 {
      let mut version_sum = 0;
      for i in 0..length_type_id {
        println!("Parsing subpacket {}", i + 1);
        // 111011100000000011 01010000001 10010000010 00110000011 00000
        // VVVTTTILLLLLLLLLLL AAAAAAAAAAA BBBBBBBBBBB CCCCCCCCCCC
        println!("Creating nested parser for mode 1");
        let mut p = Parser { input: self.input[self.pos..].to_owned(), pos: 0, version_sum: 0 };
        let c = p.parse_packet();
        version_sum += p.version_sum;
        self.pos += c;
      }
      self.version_sum += version_sum;
    }
    dbg!("exiting operator packets");
    0
  }

  fn parse_packet(&mut self) -> usize {
    let start_count = self.pos;
    dbg!(&self.input[self.pos..].iter().join(""));
    let version = self.parse_version();
    self.version_sum += version;
    dbg!(self.version_sum);
    match dbg!(self.parse_typeid()) {
      4 => {
        self.parse_literal_value();
      },
      n => {
        self.parse_operator_packets();
      },
    };
    let end_count = self.pos;
    end_count - start_count
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
    let mut p = Parser { input, pos: 0, version_sum: 0 };
    p.parse_packet();
    Some(p.version_sum.to_string())
  }

  fn part2(&self, input: &str) -> Option<String> {
    None
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
    // let input = indoc! {"D2FE28"};
    // assert_eq!(prob.part1(input), Some("6".to_string()));
    //
    // let input = indoc! {"38006F45291200"};
    // assert_eq!(prob.part1(input), Some("7".to_string()));
    //
    // let input = indoc! {"EE00D40C823060"};
    // assert_eq!(prob.part1(input), Some("14".to_string()));
    //
    // let input = indoc! {"8A004A801A8002F478"};
    // assert_eq!(prob.part1(input), Some("16".to_string()));

    // let input = indoc! {"620080001611562C8802118E34"};
    // // 011 000 1 00000000010
    // //   000 000 0 000000000010110
    // //        000 100 01010
    // //        101 100 01011
    // //   001 000 1 00000000010
    // //        000 100 01100
    // //        011 100 01101 00
    // assert_eq!(prob.part1(input), Some("12".to_string()));

    let input = indoc! {"C0015000016115A2E0802F182340"};
    // 1100000000000001010100000000000000000001011000010001010110100010111000001000000000101111000110000010001101000000
    // 110 000 0 000000001010100
    // 000 000 0 000000000010110
    //   000 100 01010
    //   110 100 01011
    // 100 000 1 000000000101111000110000010001101
    assert_eq!(prob.part1(input), Some("23".to_string()));

    let input = indoc! {"A0016C880162017C3686B18A3D4780"};
    assert_eq!(prob.part1(input), Some("31".to_string()));
    // assert_eq!(prob.part1(&get_input(16)), Some("423".to_string()));
  }

  #[test]
  fn test_day16_part2() {
    let prob = Day16 {};
    let input = indoc! {""};
    assert_eq!(prob.part2(input), None);
    // assert_eq!(prob.part2(&get_input(16)), Some("2778".to_string()));
  }
}
