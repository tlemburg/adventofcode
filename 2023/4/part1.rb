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

data = {}

full_lines = []
curr = []
lines.each do |line|
  if line == ''
    full_lines << curr
    curr = []
  else
    curr << line
  end
end
full_lines << curr

full_lines.each_with_index do |line_set, index|
  if index == 0
    data[:seeds] = line_set.first.split(':').last.strip.split(' ').map(&:to_i)
  else
    line_set.each_with_index do |line, o|
      next if o == 0
      data[index.to_s] ||= []
      data[index.to_s] << line.split(' ').map(&:to_i)
    end
  end
end

lowest = 100000000000000000000

data[:seeds].each do |seed|
  (1..7).each do |map_i|
    # transform seed
    map = data[map_i.to_s]
    map.each do |dest, source, length|
      if (source...source+length).include?(seed)
        seed = dest + seed - source
        break
      end
    end
  end

  lowest = seed if seed < lowest
end

puts lowest