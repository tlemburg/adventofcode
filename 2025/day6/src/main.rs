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

fn part1(lines: &Vec<&str>) {
    let mut total = 0;

    println!("Total: {}", total);
}

fn part2(lines: &Vec<&str>) {
    let mut total = 0;


    println!("Total: {}", total);
}
