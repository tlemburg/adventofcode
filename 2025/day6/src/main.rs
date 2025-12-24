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

    let mut numbers: Vec<Vec<i128>> = Vec::new();

    let line_count = lines.len();
    for i in 0..line_count - 1 {
        for (j, num) in lines[i].split(' ').filter(|&x| !x.is_empty()).enumerate() {
            let parsed = num.parse().expect("IT DIDNT PARSE");

            if numbers.len() <= j {
                let mut col: Vec<i128> = Vec::new();
                col.push(parsed);
                numbers.push(col);
            } else {
                let mut col = numbers.get(j).expect("NOPE").clone();
                col.push(parsed);
                numbers[j] = col;
            }
        }
    }

    for (j, op) in lines[line_count - 1]
        .split(' ')
        .filter(|&x| !x.is_empty())
        .enumerate()
    {
        let col = numbers.get(j).expect("OH NO");
        if op == "+" {
            total += col.iter().fold(0, |acc, &b| acc + b);
        } else if op == "*" {
            total += col.iter().fold(1, |acc, &b| acc * b);
        }
    }

>>>>>>> 3f78fd65aa205fbaa15128afc1c1533db6e9e3d4
    println!("Total: {}", total);
}

fn part2(lines: &Vec<&str>) {
    let mut total = 0;

    let mut accum: Vec<i128> = Vec::new();
    for j in 0..lines[0].len() {
        let col = lines[0].len() - 1 - j;
        let mut word = String::from("");
        for i in 0..lines.len() - 1 {
            let character = &lines[i][col..col + 1];
            if character == " " {
                continue;
            }
            word.push_str(character);
        }
        println!("Word: {}", word);
        if !word.is_empty() {
            accum.push(word.parse().expect("WTF NOT A NUM"));
        }

        let i = lines.len() - 1;
        if &lines[i][col..col + 1] == "+" {
            total += accum.iter().fold(0, |acc, &b| acc + b);
            accum = Vec::new();
        } else if &lines[i][col..col + 1] == "*" {
            total += accum.iter().fold(1, |acc, &b| acc * b);
            accum = Vec::new();
        }
    }

    println!("Total: {}", total);
}
