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

setups = []

lines.each_slice(4).each do |slice|
  button_a = slice[0]
  button_b = slice[1]
  prize = slice[2]

  a_arr = button_a.split(' ')
  ax = a_arr[2].split('+').last.split(',').first.to_i
  ay = a_arr[3].split('+').last.to_i

  b_arr = button_b.split(' ')
  bx = b_arr[2].split('+').last.split(',').first.to_i
  by = b_arr[3].split('+').last.to_i

  prize = prize.split(' ')
  prizex = prize[1].split('=').last.split(',').first.to_i
  prizey = prize[2].split('=').last.to_i

  setups << {
    ax:,
    ay:,
    bx:,
    by:,
    prizex:,
    prizey:
  }
end

total = 0

setups.each do |setup|

  potential_costs = []

  (1..200).each do |total_presses|
    (0..[total_presses, 100].min).each do |a_presses|
      b_presses = total_presses - a_presses
      next if b_presses > 100

      x_end = a_presses * setup.fetch(:ax) + b_presses * setup.fetch(:bx)
      y_end = a_presses * setup.fetch(:ay) + b_presses * setup.fetch(:by)
      if x_end == setup.fetch(:prizex) && y_end == setup.fetch(:prizey)
        potential_costs << 3 * a_presses + b_presses
      end
    end
  end

  unless potential_costs.empty?
    total += potential_costs.min
  end
end

puts total