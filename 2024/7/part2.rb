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

total = 0

lines.each do |line|
  first, second = line.split(':')
  target = first.to_i
  nums = second.strip.split(' ').map(&:to_i)

  operate = [nums.shift]

  while nums.any?
    next_num = nums.shift
    new_operate = []
    operate.each do |num|
      new_operate << num * next_num
      new_operate << num + next_num
      new_operate << "#{num}#{next_num}".to_i
    end
    operate = new_operate
  end

  if operate.include?(target)
    total += target
  end

end

puts total
