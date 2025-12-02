use std::fs;

fn main() {
    let contents = fs::read_to_string("input.txt").expect("Should have been able to read the file");
    let lines: Vec<&str> = contents.split('\n').collect();

    let mut total = 0;

    for line in lines {
        // Split into words, split each word into chars, sort the chars, reform to a word

        let mut words: Vec<String> = line
            .split(' ') // Split iterator
            .map(|word| {
                let mut char_array: Vec<char> = word.chars().collect();
                char_array.sort_unstable();
                return char_array.iter().collect::<String>();
            })
            .collect();

        let total_count = words.len();
        words.sort_unstable();
        words.dedup();
        let uniq_count = words.len();

        if total_count == uniq_count {
            total += 1;
        }
    }

    println!("Total: {}", total);
}
