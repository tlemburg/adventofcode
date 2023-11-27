#!/usr/bin/env ruby

require_relative '../../point'

test = ARGV[0] == '--test'

in_file = test ? 'test_in.txt' : 'real_in.txt'

lines = []
 
File.readlines(in_file, chomp: true).each do |line|
  lines << line
end

hash = {
  '1' => {d: '3'},
  '2' => {r: '3', d: '6'},
  '3' => {u: 1, l: 2, r: 4, d: 7},
  '4' => {u: 1, r: 5, d: 7},
  '5' => {u: 2, l: 4, r: 6, d: 8},
  '6' => {u: 3, l: 5, d: 9},
  '7' => {u: 4, r: 8},
  '8' => {l: 7, u: 5, r: 9},
  '9' => {l: 8, u: 6}
}

curr = 5
string = ""

lines.each do |line|
  line.chars.each do |char|
    char = char.downcase
    curr = hash[curr][char.to_sym] || curr
  end
  string << curr.to_s 
end

puts string
