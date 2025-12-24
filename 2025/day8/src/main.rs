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

    let connections = if args.contains(&"--test".to_string()) {
        10
    } else {
        1000
    };

    let contents = fs::read_to_string(filename).expect("Should have been able to read the file");
    let lines: Vec<&str> = contents.split('\n').collect();

    if args.contains(&"--part2".to_string()) {
        part2(&lines, connections);
    } else {
        part1(&lines, connections);
    }
}

#[derive(Eq, Hash, PartialEq, Debug)]
struct Point {
    x: i32,
    y: i32,
}

#[derive(Eq, Hash, PartialEq, Debug)]
struct Point3D {
    x: i128,
    y: i128,
    z: i128,
}

#[derive(Clone)]
struct Range {
    min: i128,
    max: i128,
}

fn part1(lines: &Vec<&str>, connections: i32) {
    let mut total = 0;

    let mut points: Vec<Point3D> = Vec::new();

    for line in lines {
        let nums: Vec<i128> = line
            .split(",")
            .map(|num| num.parse().expect("DIDN NOT PRASE"))
            .collect();

        points.push(Point3D {
            x: nums[0],
            y: nums[1],
            z: nums[2],
        });
    }

    // create a list of distance between all points
    let mut distances: Vec<(usize, usize, f64)> = Vec::new();
    for i in 0..points.len() {
        for j in 0..points.len() {
            if i == j {
                continue;
            }

            let distance = (((points[i].x - points[j].x).pow(2)
                + (points[i].y - points[j].y).pow(2)
                + (points[i].z - points[j].z).pow(2)) as f64)
                .sqrt();

            distances.push((i, j, distance));
        }
    }

    // Sort the distances
    distances.sort_by(|a, b| a.2.partial_cmp(&b.2).unwrap());

    // Make connections with teh shortest distances
    let mut networks: Vec<HashSet<usize>> = Vec.new();

    for i in 0..connections {
        let (conn1, conn2) = (distances[i].0, distances[i].1);
        let found_networks: Vec<usize> = Vec::new();

        for (j, network) in networks.iter().enumerate() {
            if network.contains(&conn1) {
                found_networks.push(j);
            }
            if network.contains(&conn2) {
                found_networks.push(j);
            }
        }
    }

    println!("Total: {}", distances.len());
}

fn part2(lines: &Vec<&str>, connections: i32) {
    let mut total = 0;

    println!("Total: {}", total);
}
