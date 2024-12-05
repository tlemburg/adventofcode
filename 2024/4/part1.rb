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

def valid_x(point, map)
  total = 0

  if map[point.px] == 'M' && map[point.px(2)] == 'A' && map[point.px(3)] == 'S'
    total += 1
  end
  if map[point.py] == 'M' && map[point.py(2)] == 'A' && map[point.py(3)] == 'S'
    total += 1
  end
  if map[point.mx] == 'M' && map[point.mx(2)] == 'A' && map[point.mx(3)] == 'S'
    total += 1
  end
  if map[point.my] == 'M' && map[point.my(2)] == 'A' && map[point.my(3)] == 'S'
    total += 1
  end

  if map[point.px.py] == 'M' && map[point.px(2).py(2)] == 'A' && map[point.px(3).py(3)] == 'S'
    total += 1
  end
  if map[point.mx.py] == 'M' && map[point.mx(2).py(2)] == 'A' && map[point.mx(3).py(3)] == 'S'
    total += 1
  end
  if map[point.px.my] == 'M' && map[point.px(2).my(2)] == 'A' && map[point.px(3).my(3)] == 'S'
    total += 1
  end
  if map[point.mx.my] == 'M' && map[point.mx(2).my(2)] == 'A' && map[point.mx(3).my(3)] == 'S'
    total += 1
  end
  total
end

sum = 0

map.each do |point, letter|
  if letter == 'X'
    sum += valid_x(point, map)
  end
end

puts sum