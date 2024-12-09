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

files = []

space = false
counter = 0

lines[0].chars.each do |char|
  num = char.to_i

  if space
    files += [nil] * num
  else
    files += [counter] * num
    counter += 1
  end

  space = !space
end

popped = files.count
new_files = []

files.each do |num|
  if num.nil?
    found = false
    while !found
      x = files.pop
      next unless x
      new_files << x
      found = true
    end
  else
    new_files << num
  end
end


total = 0

new_files.each_with_index do |num, i|
  total += num * i
end

puts total