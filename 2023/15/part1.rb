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

line = lines.first

instructions = line.split(',')
total_sum = 0

instructions.each do |instruction|
  current_value = 0
  instruction.chars.each do |char|
    current_value += char.ord
    current_value *= 17
    current_value %= 256
  end

  total_sum += current_value
end

puts total_sum