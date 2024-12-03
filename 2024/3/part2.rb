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
insts = []
enabled = true
total_line_length = 0

lines.each do |line|
  line.scan(/mul\(\d+,\d+\)/) do |match|
    match = match[4..-2]
    index = $~.offset(0)[0] + total_line_length
    insts << [index, match]
  end

  line.scan(/do\(\)/) do |match|
    index = $~.offset(0)[0] + total_line_length
    insts << [index, "DO"]
  end

  line.scan(/don\'t\(\)/) do |match|
    index = $~.offset(0)[0] + total_line_length
    insts << [index, "DONT"]
  end

  total_line_length += line.length
end

insts.sort_by(&:first).each do |index, inst|
  if inst == 'DO'
    enabled = true
  elsif inst == 'DONT'
    enabled = false
  else
    if enabled
      a,b = inst.split(',').map(&:to_i)
      sum += a * b
    end
  end
end

puts sum