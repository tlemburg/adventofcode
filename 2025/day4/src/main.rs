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

struct Point {
    x: i32,
    y: i32,
}

fn part1(lines: &Vec<&str>) {
    let mut total = 0;
    let min_x = 0;
    let min_y = 0;
    let max_x = lines[0].len() - 1;
    let max_y = lines.count() - 1;

    println!("Total: {}", total);
}

fn part2(lines: &Vec<&str>) {
    let mut total = 0;

    total += 1;

    println!("Total: {}", total);
}
