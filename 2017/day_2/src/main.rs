use std::fs;

fn main() {
    // Read in from a file
    let contents = fs::read_to_string("input.txt").expect("Should have been able to read the file");
    let lines = contents.split('\n');

    let mut sum = 0;

    for line in lines {
        let numbers: Vec<i32> = line
            .split(' ')
            .filter(|s| !s.is_empty())
            .map(|s| {
                return s.parse::<i32>().expect("not a good number");
            })
            .collect();

        for (i, number) in numbers.iter().enumerate() {
            for (j, number2) in numbers.iter().enumerate() {
                if (j > i) {
                    if (number % number2 == 0) {
                        sum += number / number2;
                    } else if (number2 % number == 0) {
                        sum += number2 / number;
                    }
                }
            }
        }
    }

    println!("Sum is {sum}")
}
