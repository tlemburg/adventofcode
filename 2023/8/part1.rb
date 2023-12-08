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

dirs = lines.shift
lines.shift
map = {}

lines.each do |line|
  node = line.split(' = ').first
  left = line.split('(').last[0..2]
  right = line.split(', ').last[0..2]
  map[node] = {'L' => left, 'R' => right}
end

puts map.inspect

curr = 'AAA'
count = 0
index = 0
until curr == 'ZZZ'
  dir = dirs[index]
  curr = map[curr][dir]
  index = (index + 1) % dirs.length
  count += 1
end

puts count