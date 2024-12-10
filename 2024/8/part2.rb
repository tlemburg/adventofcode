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

nodes = {}
map.each do |point, letter|
  next if letter == '.'

  nodes[letter] ||= []
  nodes[letter] << point
end

antinodes = Set[]

nodes.each do |letter, points|
  (0..points.count-2).each do |i|
    (i+1..points.count-1).each do |j|
      x_diff = points[j].x - points[i].x
      y_diff = points[j].y - points[i].y

      new_point_1 = points[j]
      while x_range.include?(new_point_1.x) && y_range.include?(new_point_1.y)
        antinodes << new_point_1
        new_point_1 = new_point_1.px(x_diff).py(y_diff)
      end

      new_point_2 = points[i]
      while x_range.include?(new_point_2.x) && y_range.include?(new_point_2.y)
        antinodes << new_point_2
        new_point_2 = new_point_2.mx(x_diff).my(y_diff)
      end
    end
  end
end


puts antinodes.count