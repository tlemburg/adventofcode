#!/usr/bin/env ruby

test = ARGV[0] == '--test'

in_file = test ? 'test_in.txt' : 'real_in.txt'

lines = []
 
File.readlines(in_file, chomp: true).each do |line|
  lines << line
end

count = 0
lines.each do |line|
  minmax, letter, pass = line.split(' ')
  min, max = minmax.split('-').map(&:to_i)
  letter = letter[0]

  letter_count = pass.chars.select do |char|
    char == letter
  end.count

  if letter_count >= min && letter_count <= max
    count += 1
  end
end

puts count
