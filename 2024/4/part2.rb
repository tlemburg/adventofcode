#!/usr/bin/env ruby

require_relative '../../point'
require 'set'

test = ARGV[0] == '--test'

in_file = test ? 'test_in.txt' : 'real_in.txt'

lines = []
map = {}
map.default = 't'
 
File.readlines(in_file, chomp: true).each_with_index do |line, y|
  lines << line
  line.chars.each_with_index do |char, x|
    map[Point.new(x,y)] = char
  end
end

# Assuming the map is a rectangle
x_max = lines[0].length - 1
y_max = lines.count - 1

def valid_m(point, map)
  total = 0

  if map[point.px.py] == 'A' && map[point.px(2).py(2)] == 'S' && [map[point.px.py.px.my], map[point.px.py.mx.py]].sort == ['M', 'S']
    total += 1
  end
  if map[point.mx.my] == 'A' && map[point.mx(2).my(2)] == 'S' && [map[point.mx.my.px.my], map[point.mx.my.mx.py]].sort == ['M', 'S']
    total += 1
  end
  if map[point.mx.py] == 'A' && map[point.mx(2).py(2)] == 'S' && [map[point.mx.py.px.py], map[point.mx.py.mx.my]].sort == ['M', 'S']
    total += 1
  end
  if map[point.px.my] == 'A' && map[point.px(2).my(2)] == 'S' && [map[point.px.my.px.py], map[point.px.my.mx.my]].sort == ['M', 'S']
    total += 1
  end
  total
end

sum = 0

map.each do |point, letter|
  if letter == 'M'
    sum += valid_m(point, map)
  end
end

puts sum / 2