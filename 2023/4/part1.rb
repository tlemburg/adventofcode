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

result = 0

lines.each do |line|
  arrs = line.split(':').last.split('|')
  arr1 = arrs[0].strip.split(' ').map(&:to_i)
  arr2 = arrs[1].strip.split(' ').map(&:to_i)

  matches = 0

  arr2.each do |num|
    if arr1.include?(num)
      matches += 1
    end
  end

  if matches > 0
    result += 2**(matches-1)
  end
end

puts result