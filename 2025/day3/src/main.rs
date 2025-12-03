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

    for line in lines {
        let chars: Vec<char> = line.chars().collect();
        let mut largest = 0;
        for i in 0..(chars.len() - 1) {
            for j in (i + 1)..chars.len() {
                let number: i32 = format!("{}{}", chars[i], chars[j])
                    .parse()
                    .expect("Didnt parse");
                if number > largest {
                    largest = number;
                }
            }
        }

        total += largest;
    }

    println!("Total: {}", total);
}

fn part2(lines: &Vec<&str>) {
    let mut total: u128 = 0;

    for line in lines {
        let chars: Vec<char> = line.chars().collect();

        // Start with the first 12 characters.
        let mut largest: u128 = chars[0..12]
            .iter()
            .collect::<String>()
            .parse()
            .expect("could not parse first largest");

        // iterate through each character beyond
        for i in 12..chars.len() {
            // try replacing each character in the current largest with this one
            let new_char = chars[i];
            let current_string = largest.to_string();
            for j in 0..current_string.len() {
                let new_string = format!(
                    "{}{}{}",
                    &current_string[..j],
                    &current_string[j + 1..],
                    new_char
                );
                let new_number: u128 = new_string.parse().expect("could not parse new number");
                if new_number > largest {
                    largest = new_number;
                }
            }

            // test whether this new value is larger
        }

        println!("Largest: {}", largest);
        total += largest;
    }

    println!("Total: {}", total);
}
