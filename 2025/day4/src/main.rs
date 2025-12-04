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
    let min_x: i32 = 0;
    let min_y: i32 = 0;
    let max_x: i32 = (lines[0].len() - 1) as i32;
    let max_y: i32 = (lines.len() - 1) as i32;

    let mut rolls = HashSet::<Point>::new();

    for (y, line) in lines.iter().enumerate() {
        for (x, character) in line.chars().enumerate() {
            if character == '@' {
                rolls.insert(Point {
                    x: x as i32,
                    y: y as i32,
                });
            }
        }
    }

    for x in min_x..=max_x {
        for y in min_y..=max_y {
            if rolls.contains(&Point { x, y }) {
                let mut adjacent = 0;
                for i in (x - 1)..=(x + 1) {
                    for j in (y - 1)..=(y + 1) {
                        if rolls.contains(&Point { x: i, y: j }) {
                            adjacent += 1;
                        }
                    }
                }
                if adjacent <= 4 {
                    total += 1;
                }
            }
        }
    }

    println!("Total: {}", total);
}

fn part2(lines: &Vec<&str>) {
    let mut total = 0;
    let min_x: i32 = 0;
    let min_y: i32 = 0;
    let max_x: i32 = (lines[0].len() - 1) as i32;
    let max_y: i32 = (lines.len() - 1) as i32;

    let mut rolls = HashSet::<Point>::new();

    for (y, line) in lines.iter().enumerate() {
        for (x, character) in line.chars().enumerate() {
            if character == '@' {
                rolls.insert(Point {
                    x: x as i32,
                    y: y as i32,
                });
            }
        }
    }

    loop {
        let mut removed = HashSet::<Point>::new();
        for x in min_x..=max_x {
            for y in min_y..=max_y {
                if rolls.contains(&Point { x, y }) {
                    let mut adjacent = 0;
                    for i in (x - 1)..=(x + 1) {
                        for j in (y - 1)..=(y + 1) {
                            if rolls.contains(&Point { x: i, y: j }) {
                                adjacent += 1;
                            }
                        }
                    }
                    if adjacent <= 4 {
                        total += 1;
                        removed.insert(Point { x, y });
                    }
                }
            }
        }
        if removed.len() == 0 {
            break;
        } else {
            for point in removed {
                rolls.remove(&point);
            }
        }
    }

    println!("Total: {}", total);
}
