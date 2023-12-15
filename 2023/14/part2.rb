#!/usr/bin/env ruby

require_relative '../../point'

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
y_max = lines.count - 1
x_max = lines[0].length - 1

(0..y_max).each do |y|
  # for each line, move all rocks north in that line
  # and then all the lines above it
  (0..y).to_a.reverse.each do |this_y|
    (0..x_max).each do |x|
      point = Point.new(x, this_y)
      if map[point] == 'O' && map[point.my] == '.'
        map[point.my] = 'O'
        map[point] = '.'
      end
    end
  end
end

total = map.select do |point, value|
  value == 'O'
end.keys.map do |point|
  y_max + 1 - point.y
end.inject(&:+)

puts total