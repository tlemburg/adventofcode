#!/usr/bin/env ruby

test = ARGV[0] == '--test'

in_file = test ? 'test_in.txt' : 'real_in.txt'

lines = []
 
File.readlines(in_file, chomp: true).each do |line|
  lines << line
end

gamma = (0...lines[0].length).to_a.map do |i|
  chars = lines.map { |line| line[i] }
  tally = chars.tally
  tally['0'] > tally['1'] ? '0' : '1'
end.join

epsilon = gamma.chars.map do |char|
  char == '1' ? '0' : '1'
end.join  

puts gamma.to_i(2) * epsilon.to_i(2)
