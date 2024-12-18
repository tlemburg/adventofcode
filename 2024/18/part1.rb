#!/usr/bin/env ruby

require_relative '../../point'
require 'set'

test = ARGV[0] == '--test'

in_file = test ? 'test_in.txt' : 'real_in.txt'

lines = []
map = {}
 
File.readlines(in_file, chomp: true).each_with_index do |line, y|
  lines << line
end

x_max = test ? 6 : 70
y_max = test ? 6 : 70
falling_bytes = test ? 12 : 1024
x_range = (0..x_max)
y_range = (0..y_max)

lines.first(falling_bytes).each do |line|
  x, y = line.split(',').map(&:to_i)
  map[Point.new(x,y)] = '#'
end

distances = {}
queue = []

## Dijkstra's
(0..x_max).each do |x|
  (0..y_max).each do |y|
    point = Point.new(x,y)
    queue << point
    distances[point] = Float::INFINITY
  end
end

distances[Point.new(0,0)] = 0

until queue.empty?
  queue.sort_by! do |point|
    distances.fetch(point)
  end

  curr = queue.shift
  if curr.x == x_max && curr.y == y_max
    puts "DONE"
    puts distances.fetch(curr)
    exit
  end

  [curr.px, curr.py, curr.mx, curr.my].each do |next_point|
    if queue.include?(next_point) && map[next_point] != '#'
      dist = distances.fetch(curr) + 1
      if dist < distances.fetch(next_point)
        distances[next_point] = dist
      end
    end
  end
end

