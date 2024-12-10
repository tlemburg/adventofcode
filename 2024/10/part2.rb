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
x_range = (0..x_max)
y_range = (0..y_max)

heads = {} # point => 9's reached

map.each do |point, char|
  if char == '0'
    puts "PROCESSING 0 at #{point}"

    heads[point] = []

    # start a bfs
    queue = [point]
    until queue.empty?
      curr_point = queue.shift

      val = map[curr_point].to_i
      puts "Curr Point #{curr_point}: val #{val}"

      if val == 9
        heads[point] << curr_point
      else
        if map[curr_point.px].to_i == val + 1
          queue << curr_point.px
        end
        if map[curr_point.mx].to_i == val + 1
          queue << curr_point.mx
        end
        if map[curr_point.py].to_i == val + 1
          queue << curr_point.py
        end
        if map[curr_point.my].to_i == val + 1
          queue << curr_point.my
        end

      end

    end
  end
end

total = heads.values.map(&:count).sum

puts total