use std::fs;

fn main() {
    let contents = fs::read_to_string("input.txt").expect("Should have been able to read the file");
    let lines: Vec<&str> = contents.split('\n').collect();

    let line = lines[0];

    let mut total: i64 = 0;

    let ranges = line.split(',');

    for range in ranges {
        let nums: Vec<i64> = range.split('-').map(|st| st.parse().expect("Could not parse int")).collect();
        let start = nums[0];
        let end = nums[1];

        'main_i_loop: for i in start..=end {
            let string = i.to_string();
            'modulus_loop: for modulus in 1..=(string.len() / 2) {
                if string.len() % modulus == 0 {
                    // get the first set
                    let target = &string[0..modulus];
                    for j in 1..(string.len() / modulus) {
                        if &string[(j * modulus)..((j+1) * modulus)] != target {
                            continue 'modulus_loop;
                        }
                    }
                    total += i;
                    continue 'main_i_loop;
                }
            }
        }
    }

    println!("TOTAL: {}", total);
}
