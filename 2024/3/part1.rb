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


sum = 0

lines.each do |line|

matches = line.scan(/mul\(\d+,\d+\)/)
matches.each do |match|
  puts match
  match = match[4..-2]
  a,b = match.split(',').map(&:to_i)
  sum += a * b
end
end
puts sum