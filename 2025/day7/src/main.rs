use std::collections::HashSet;
use std::env;
use std::fs;

fn main() {
    let args: Vec<String> = env::args().collect();

    let filename = if args.contains(&"--test".to_string()) {
        "test.txt"
    } else {
        "input.txt"
    };

    let contents = fs::read_to_string(filename).expect("Should have been able to read the file");
    let lines: Vec<&str> = contents.split('\n').collect();

    if args.contains(&"--part2".to_string()) {
        part2(&lines);
    } else {
        part1(&lines);
    }
}

#[derive(Eq, Hash, PartialEq, Debug)]
struct Point {
    x: i32,
    y: i32,
}

#[derive(Clone)]
struct Range {
    min: i128,
    max: i128,
}

fn part1(lines: &Vec<&str>) {
    let mut total = 0;

    let mut chars: Vec<Vec<char>> = Vec::new();
    for i in 0..lines.len() {
        chars.push(lines[i].chars().collect());
    }

    for i in 0..chars.len() {
        for j in 0..chars[0].len() {
            if chars[i][j] == 'S' || chars[i][j] == '|' {
                if i < chars.len() - 1 {
                    let receiver = chars[i + 1][j];
                    if receiver == '^' {
                        total += 1;
                        if j > 0 {
                            chars[i + 1][j - 1] = '|';
                        }
                        if j < chars[0].len() - 1 {
                            chars[i + 1][j + 1] = '|';
                        }
                    } else {
                        chars[i + 1][j] = '|';
                    }
                }
            }
        }
    }

    println!("Total: {}", total);
}

fn part2(lines: &Vec<&str>) {
    let mut total = 0;

    let mut chars: Vec<Vec<char>> = Vec::new();
    let mut timelines: Vec<Vec<u128>> = Vec::new();
    for i in 0..lines.len() {
        chars.push(lines[i].chars().collect());
        timelines.push(Vec::new());
        for j in 0..lines[0].len() {
            timelines[i].push(0);
        }
    }

    for i in 0..chars.len() {
        for j in 0..chars[0].len() {
            if chars[i][j] == 'S' || chars[i][j] == '|' {
                if chars[i][j] == 'S' {
                    timelines[i][j] = 1;
                }
                if i < chars.len() - 1 {
                    let receiver = chars[i + 1][j];
                    if receiver == '^' {
                        if j > 0 {
                            chars[i + 1][j - 1] = '|';
                            timelines[i + 1][j - 1] = timelines[i + 1][j - 1] + timelines[i][j];
                        }
                        if j < chars[0].len() - 1 {
                            chars[i + 1][j + 1] = '|';
                            timelines[i + 1][j + 1] = timelines[i + 1][j + 1] + timelines[i][j];
                        }
                    } else {
                        chars[i + 1][j] = '|';
                        timelines[i + 1][j] = timelines[i + 1][j] + timelines[i][j];
                    }
                }
            }
        }
    }

    total = timelines[chars.len() - 1].iter().fold(0, |acc, &b| acc + b);

    println!("Total: {}", total);
}
