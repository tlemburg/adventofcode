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
  x1 = a_arr[2].split('+').last.split(',').first.to_i
  y1 = a_arr[3].split('+').last.to_i

  b_arr = button_b.split(' ')
  x2 = b_arr[2].split('+').last.split(',').first.to_i
  y2 = b_arr[3].split('+').last.to_i

  prize = prize.split(' ')
  xp = prize[1].split('=').last.split(',').first.to_i + 10000000000000
  yp = prize[2].split('=').last.to_i + 10000000000000

  setups << {
    x1:,
    x2:,
    y1:,
    y2:,
    xp:,
    yp:
  }
end

total = 0

setups.each do |setup|

  x1 = setup.fetch(:x1)
  x2 = setup.fetch(:x2)
  y1 = setup.fetch(:y1)
  y2 = setup.fetch(:y2)
  xp = setup.fetch(:xp)
  yp = setup.fetch(:yp)

  a_denom = x1*y2 - x2 * y1

  if a_denom == 0
    # The buttons are multiples of one another.
    # Need to push the most efficient button
  else
    a_num = xp*y2 - x2*yp
    if a_num % a_denom == 0
      a = a_num / a_denom
      b_num = yp - a*y1
      b_denom = y2
      if b_num % b_denom == 0
        b = b_num / b_denom
        puts setup
        puts "A: #{a} B: #{b}"

        total += 3*a + b
        next
      end
    end
  end

end

puts total