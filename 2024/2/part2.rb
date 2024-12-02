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

def safe?(nums)
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
end

puts (lines.select do |line|
  nums = line.split(' ').map(&:to_i)

  if safe?(nums)
    true
  else
    found = false
    (0..(nums.length-1)).each do |i|
      new_arr = []
      if i != 0
        new_arr += nums[0..(i-1)]
      end
      if i != nums.length - 1
        new_arr += nums[(i+1)..(nums.length - 1)]
      end

      if safe?(new_arr)
        found = true
        break
      end
    end
    found
  end
end.count)