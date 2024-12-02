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

puts (lines.select do |line|
  nums = line.split(' ').map(&:to_i)
  if nums.sort == nums || nums.sort.reverse == nums
    broken = false

    (0...nums.count - 1).each do |i|
      diff =  (nums[i] - nums[i+1]).abs
      if diff > 3 || diff < 1
        broken = true
        break
      end
    end

    !broken
  else
    false
  end
end.count)