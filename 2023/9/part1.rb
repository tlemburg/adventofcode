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

total = 0

lines.each do |line|
  arrays = []
  arrays << line.split(' ').map(&:to_i)
  curr = arrays.first

  until curr.all?(&:zero?)
    new_array = (0..curr.length-2).to_a.map do |i|
      curr[i+1] - curr[i]
    end

    arrays << new_array
    curr = arrays.last
  end

  next_val = arrays.map(&:last).sum
  total += next_val
  puts next_val
end

puts total