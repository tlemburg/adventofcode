#!/usr/bin/env ruby

test = ARGV[0] == '--test'

in_file = test ? 'test_in.txt' : 'real_in.txt'

lines = []
 
File.readlines(in_file, chomp: true).each do |line|
  lines << line
end

count = 0
lines[1..-1].each_with_index do |line, i|
  col = ((i+1) * 3) % line.length
  count += 1 if line[col] == '#'
end

puts count
