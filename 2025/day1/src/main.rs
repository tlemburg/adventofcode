use std::fs;

fn main() {
    let contents = fs::read_to_string("input.txt").expect("Should have been able to read the file");
    let lines: Vec<&str> = contents.split('\n').collect();

    let mut dial: i32 = 50;
    let mut total: i32 = 0;

    for line in lines {
        let letter = line.chars().collect::<Vec<_>>()[0];
        let turn: u32 = line[1..].parse().expect("Oh no couldn't parse the dial turn");

        if letter == 'R' {
            for i in 0..turn {
                dial -= 1;
                dial = dial % 100;
                if dial == 0 {
                    total += 1;
                }
            }
        } else {
            for i in 0..turn {
                dial += 1;
                dial = dial % 100;
                if dial == 0 {
                    total += 1;
                }
            }
        }
    }

    println!("Total: {}", total);
}
