use std::fs;

fn main() {
    // Read in from a file

    let contents = fs::read_to_string("input.txt").expect("Should have been able to read the file");
    let lines: Vec<&str> = contents.split('\n').collect();

    let mut sum = 0;
    let chars = lines[0].trim().chars();

    let v: Vec<char> = chars.collect();
    let size = v.len();

    for i in 0..(size / 2) {
        if v[i] == v[i + size / 2] {
            let num: u32 = v[i].to_string().parse().expect("no go");
            sum += 2 * num;
        }
    }

    // output sum
    println!("Final sum: {sum}")
}
