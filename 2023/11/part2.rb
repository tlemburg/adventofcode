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

lines_copy = []
lines.each do |line|
  lines_copy << line.dup
  if line.chars.uniq == ['.']
    lines_copy << line.dup
  end
end

lines = lines_copy.dup
lines_copy = []
x_to_expand = []

(0...lines[0].length).each do |i|
  if lines.map { |line| line[i] }.uniq == ['.']
    x_to_expand << i
  end
end

lines.each do |line|
  inserted = 0
  line_copy = line.dup
  x_to_expand.each do |x|
    line_copy.insert(x + inserted, '.')
    inserted += 1
  end

  lines_copy << line_copy
end

lines = lines_copy.dup

map = {}
lines.each_with_index do |line, y|
  line.chars.each_with_index do |char, x|
    map[Point.new(x,y)] = char
  end
end

galaxies = map.select do |key, value|
  value == '#'
end.keys

total = 0
(0...galaxies.count).each do |i|
  gal1 = galaxies[i]
  (i+1...galaxies.count).each do |j|
    gal2 = galaxies[j]
    total += gal1.manhattan(gal2)
  end
end

puts total
