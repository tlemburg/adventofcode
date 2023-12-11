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

y_empty = []
x_empty = []

lines.each_with_index do |line, y|
  if line.chars.uniq == ['.']
    y_empty << y
  end
end

(0...lines[0].length).each do |x|
  if lines.map {|line| line[x]}.uniq == ['.']
    x_empty << x
  end
end

galaxies = map.select do |key, value|
  value == '#'
end.keys

EMPTY_SPACE = 1000000

total = 0
(0...galaxies.count).each do |i|
  gal1 = galaxies[i]
  (i+1...galaxies.count).each do |j|
    gal2 = galaxies[j]
    manhattan = gal1.manhattan(gal2)

    x_range = ([gal1.x, gal2.x].sort.first..[gal1.x, gal2.x].sort.last)
    y_range = ([gal1.y, gal2.y].sort.first..[gal1.y, gal2.y].sort.last)

    empty_count = 0
    x_empty.each do |x|
      if x_range.include?(x)
        empty_count += 1
      end
    end
    y_empty.each do |y|
      if y_range.include?(y)
        empty_count += 1
      end
    end

    total += manhattan + empty_count * (EMPTY_SPACE - 1)

  end
end

puts total
