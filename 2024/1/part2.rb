#!/usr/bin/env ruby

require_relative '../../point'
require 'set'

test = ARGV[0] == '--test'

in_file = test ? 'test_in.txt' : 'real_in.txt'

lines = []
map = {}
 
File.readlines(in_file, chomp: true).each_with_index do |line, y|
  lines << line
  line.chars.each_with_index do |char, x|
    map[Point.new(x,y)] = char
  end
end

x_max = lines[0].length - 1
y_max = lines.count - 1

list_1 = []
list_2 = []

lines.each do |line|
  arr = line.split('  ').map(&:to_i)
  list_1 << arr[0]
  list_2 << arr[1]
end

list_1.sort!
list_2.sort!

tally = list_2.tally

sum = 0
list_1.each_with_index do |num, i|
  sum += num * tally.fetch(num, 0)
end

puts sum
