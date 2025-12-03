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

fn part1(lines: &Vec<&str>) {
    let mut total = 0;
    let mut point: i32 = 0;

    let mut insts: Vec<i32> = lines
        .iter()
        .map(|line| line.parse().expect("couldnt parse"))
        .collect();

    loop {
        if point < 0 || point >= insts.len().try_into().unwrap() {
            break;
        }

        let inst = insts[point as usize];
        insts[point as usize] = insts[point as usize] + 1;
        point += inst;

        total += 1;
    }

    println!("Total: {}", total);
}

fn part2(lines: &Vec<&str>) {
    let mut total = 0;
    let mut point: i32 = 0;

    let mut insts: Vec<i32> = lines
        .iter()
        .map(|line| line.parse().expect("couldnt parse"))
        .collect();

    loop {
        if point < 0 || point >= insts.len().try_into().unwrap() {
            break;
        }

        let inst = insts[point as usize];
        if inst >= 3 {
            insts[point as usize] = insts[point as usize] - 1;
        } else {
            insts[point as usize] = insts[point as usize] + 1;
        }
        point += inst;

        total += 1;
    }

    println!("Total: {}", total);
}
