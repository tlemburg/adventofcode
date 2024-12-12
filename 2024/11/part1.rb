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

# Assuming the map is a rectangle
x_max = lines[0].length - 1
y_max = lines.count - 1
x_range = (0..x_max)
y_range = (0..y_max)

stones = []

stones = lines[0].split(' ').map(&:to_i)

25.times do |i|
  new_stones = []
  stones.each do |stone|
    if stone == 0
      new_stones << 1
    elsif stone.to_s.length.even?
      new_stones << stone.to_s[0..(stone.to_s.length / 2 - 1)].to_i
      new_stones << stone.to_s[(stone.to_s.length / 2)..stone.to_s.length-1].to_i
    else
      new_stones << stone * 2024
    end
  end

  stones = new_stones
end

puts stones.length
