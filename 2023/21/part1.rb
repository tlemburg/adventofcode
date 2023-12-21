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

STEPS = test ? 6 : 64

start = map.select do |key, value|
  value == 'S'
end.keys.first

curr_spots = [start]
next_spots = []

STEPS.times do |i|

  curr_spots.each do |curr|
    if map[curr.px] == '.'
      next_spots << curr.px
    end
    if map[curr.mx] == '.'
      next_spots << curr.mx
    end
    if map[curr.py] == '.'
      next_spots << curr.py
    end
    if map[curr.my] == '.'
      next_spots << curr.my
    end
  end

  map[start] = '.'

  curr_spots = next_spots.uniq
  next_spots = []
end

puts curr_spots.count