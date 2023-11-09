#!/usr/bin/env ruby

test = ARGV[0] == '--test'

in_file = test ? 'test_in.txt' : 'real_in.txt'

lines = []
 
File.readlines(in_file, chomp: true).each do |line|
  lines << line
end

y = 0
x = 0
aim = 0
lines.each do |line|
  direction, num = line.split(' ')
  num = num.to_i
  case direction
  when 'forward'
    x += num
    y += aim * num
  when 'down'
    aim += num
  when 'up'
    aim -= num
  end
end

puts x*y
