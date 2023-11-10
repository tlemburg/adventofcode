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



  if (pass[min-1] == letter) ^ (pass[max-1] == letter)
    count += 1
  end
end

puts count
