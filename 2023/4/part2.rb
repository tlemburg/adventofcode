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
card_count = (0...lines.count).to_a.map do |i|
  [i, 1]
end.to_h

lines.each_with_index do |line, line_num|
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
    (1..matches).each do |i|
      card_count[line_num + i] += card_count[line_num] if card_count.key?(line_num+i)
    end
  end

end

puts card_count.inspect
puts card_count.values.sum