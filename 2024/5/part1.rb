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

gap_hit = false

orderings = {}
updates = []

lines.each do |line|
  if line == ''
    gap_hit = true
    next
  end

  if !gap_hit
    before, after = line.split('|').map(&:to_i)
    orderings[before] ||= []
    orderings[before] << after
  else
    updates << line.split(',').map(&:to_i)
  end
end

total = 0

updates.each do |update|
  failed = false
  update.each_with_index do |num, i|
    next if i == 0

    if (update[0..i] & orderings.fetch(num, [])).any?
      failed = true
      break
    end
  end


  total += update[(update.count-1) / 2] unless failed
end

puts total