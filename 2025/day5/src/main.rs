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
    let mut gap_found = false;

    let mut ranges: Vec<Range> = Vec::new();

    for line in lines {
        if gap_found {
            let num: i128 = line.parse().expect("failure to parse");
            for range in &ranges {
                if range.min <= num && num <= range.max {
                    total += 1;
                    break;
                }
            }
        } else {
            if line == &"" {
                gap_found = true;
                continue;
            }

            let minmax: Vec<i128> = line
                .split('-')
                .map(|num| num.parse().expect("TOTAL FAILURE"))
                .collect();
            ranges.push(Range {
                min: minmax[0],
                max: minmax[1],
            });
        }
    }

    println!("Total: {}", total);
}

fn part2(lines: &Vec<&str>) {
    let mut total = 0;

    let mut gap_found = false;

    let mut ranges: Vec<Range> = Vec::new();

    for line in lines {
        if gap_found {
            break;
        } else {
            if line == &"" {
                gap_found = true;
                continue;
            }

            let minmax: Vec<i128> = line
                .split('-')
                .map(|num| num.parse().expect("TOTAL FAILURE"))
                .collect();
            ranges.push(Range {
                min: minmax[0],
                max: minmax[1],
            });
        }
    }

    ranges.sort_by(|a, b| a.min.cmp(&b.min));

    let mut current: Range = ranges[0].clone();

    for range in ranges {
        println!("Current: {}-{}", current.min, current.max);
        println!("Operating on {}-{}", range.min, range.max);

        if range.min >= current.min && range.min <= current.max {
            // set current.max to the maximum of current.max and range.max
            if range.max > current.max {
                current.max = range.max;
            }
        } else {
            println!("Totaling on range: {}-{}", current.min, current.max);
            total += current.max - current.min + 1;
            current = range;
        }
    }

    println!("Current: {}-{}", current.min, current.max);
    println!("Totaling on range: {}-{}", current.min, current.max);
    total += current.max - current.min + 1;

    println!("Total: {}", total);
}
