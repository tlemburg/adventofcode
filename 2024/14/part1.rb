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

width = 101
height = 103

quadrants = [0,0,0,0]

lines.each do |line|
  regex = /\Ap=(?<px>\d+),(?<py>\d+) v=(?<vx>-?\d+),(?<vy>-?\d+)\z/
  match = line.match(regex)
  px = match[:px].to_i
  py = match[:py].to_i
  vx = match[:vx].to_i
  vy = match[:vy].to_i

  px = (px + 100 * vx) % width
  py = (py + 100 * vy) % height

  puts "#{px},#{py}"

  if px < 50
    if py < 51
      quadrants[0] = quadrants[0] + 1
    elsif py >= 52
      quadrants[1] = quadrants[1] + 1
    end
  elsif px >= 51
    if py < 51
      quadrants[2] = quadrants[2] + 1
    elsif py >= 52
      quadrants[3] = quadrants[3] + 1
    end
  end
end

puts quadrants.reduce(&:*)