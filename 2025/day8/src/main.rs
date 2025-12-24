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
    let mut total: u128 = 1;

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
        for j in i + 1..points.len() {
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
    let mut networks: Vec<HashSet<usize>> = Vec::new();

    // for every connection we are going to make (10 for test, 1000 for prod)
    for i in 0..connections {
        let (node1, node2) = (distances[i as usize].0, distances[i as usize].1);
        let mut found_networks: Vec<usize> = Vec::new();

        // look through each network to see if the node is already present
        for (j, network) in networks.iter().enumerate() {
            if network.contains(&node1) {
                found_networks.push(j);
            }
            if network.contains(&node2) {
                found_networks.push(j);
            }
        }

        // if no networks found, then create a new network
        if found_networks.len() == 0 {
            let mut new_set = HashSet::new();
            new_set.insert(node1);
            new_set.insert(node2);

            networks.push(new_set);
        }
        if found_networks.len() == 1 {
            networks[found_networks[0]].insert(node1);
            networks[found_networks[0]].insert(node2);
        }
        if found_networks.len() == 2 {
            // combine the networks if the found networks are not already the same
            if found_networks[0] != found_networks[1] {
                let mut new_set = HashSet::new();
                for x in networks[found_networks[0]].clone() {
                    new_set.insert(x);
                }
                for x in networks[found_networks[1]].clone() {
                    new_set.insert(x);
                }
                networks.push(new_set);
                networks[found_networks[0]] = HashSet::new();
                networks[found_networks[1]] = HashSet::new();
            }
        }
    }

    networks.sort_by(|a, b| b.len().cmp(&a.len()));

    for i in 0..3 {
        total *= networks[i].len() as u128;
    }

    println!("Total: {}", total);
}

fn part2(lines: &Vec<&str>, connections: i32) {
    let mut total: u128 = 1;

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
        for j in i + 1..points.len() {
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
    let mut networks: Vec<HashSet<usize>> = Vec::new();
    let mut connected: Vec<usize> = Vec::new();
    let mut i: usize = 0;

    // for every connection we are going to make (10 for test, 1000 for prod)
    loop {
        connected.push(distances[i].0);
        connected.push(distances[i].1);
        let (node1, node2) = (distances[i].0, distances[i].1);

        i += 1;

        let mut found_networks: Vec<usize> = Vec::new();

        // look through each network to see if the node is already present
        for (j, network) in networks.iter().enumerate() {
            if network.contains(&node1) {
                found_networks.push(j);
            }
            if network.contains(&node2) {
                found_networks.push(j);
            }
        }

        // if no networks found, then create a new network
        if found_networks.len() == 0 {
            let mut new_set = HashSet::new();
            new_set.insert(node1);
            new_set.insert(node2);

            networks.push(new_set);
        }
        if found_networks.len() == 1 {
            networks[found_networks[0]].insert(node1);
            networks[found_networks[0]].insert(node2);
        }
        if found_networks.len() == 2 {
            // combine the networks if the found networks are not already the same
            if found_networks[0] != found_networks[1] {
                let mut new_set = HashSet::new();
                for x in networks[found_networks[0]].clone() {
                    new_set.insert(x);
                }
                for x in networks[found_networks[1]].clone() {
                    new_set.insert(x);
                }
                networks.push(new_set);
                networks[found_networks[0]] = HashSet::new();
                networks[found_networks[1]] = HashSet::new();
            }
        }

        // clear out any hashsets that are empty
        networks.retain(|set| !set.is_empty());

        if networks.len() == 1 && networks[0].len() == points.len() {
            break;
        }
    }

    total = points[connected[connected.len() - 1]].x as u128
        * points[connected[connected.len() - 2]].x as u128;

    println!("Total: {}", total);
}
