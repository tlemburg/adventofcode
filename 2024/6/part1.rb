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

guard_point = map.select do |point, char|
  char == '^'
end.to_a.first.first
guard_dir = :up


while x_range.include?(guard_point.x) && y_range.include?(guard_point.y)
  map[guard_point] = 'X'

  case guard_dir
  when :up
    if map[guard_point.my] == '#'
      guard_dir = :right
    else
      guard_point = guard_point.my
    end
  when :down
    if map[guard_point.py] == '#'
      guard_dir = :left
    else
      guard_point = guard_point.py
    end

  when :left
    if map[guard_point.mx] == '#'
      guard_dir = :up
    else
      guard_point = guard_point.mx
    end
  when :right
    if map[guard_point.px] == '#'
      guard_dir = :down
    else
      guard_point = guard_point.px
    end
  end
end

total = map.select do |point, char|
  char == "X"
end.count

puts total