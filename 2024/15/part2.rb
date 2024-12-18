#!/usr/bin/env ruby

require_relative '../../point'
require 'set'

test = ARGV[0] == '--test'

in_file = test ? 'test_in.txt' : 'real_in.txt'

lines = []
map = {}
 
gap_found = false
inputs = []
File.readlines(in_file, chomp: true).each_with_index do |line, y|
  if line.empty?
    gap_found = true
    next
  end

  if gap_found
    inputs += line.chars
  else
    lines << line
    line.chars.each_with_index do |char, x|
      map[Point.new(x,y)] = char
    end
  end
end

# Assuming the map is a rectangle
x_max = lines[0].length - 1
y_max = lines.count - 1
x_range = (0..x_max)
y_range = (0..y_max)

robot_curr = map.select do |point, char|
  char == '@'
end.keys.first

inputs.each do |input|
  # The points we are going to move in a certain direction
  points_to_move = [robot_curr]

  move_method = case input
  when '<'
    :mx
  when '>'
    :px
  when '^'
    :my
  when 'v'
    :py
  else
    raise 'Invalid input'
  end

  # The point we are currently looking at as we check which points to move
  # look at the first point in that direction
  looking_at = robot_curr.send(move_method)

  # look in the direction and find any boxes we will push
  while map[looking_at] == 'O'
    points_to_move << looking_at
    looking_at = looking_at.send(move_method)
  end

  # Afterward we are looking at a wall '#' or a space '.'
  # Move it if it's a space
  if map[looking_at] == '.'
    # Move the furthest boxes first
    points_to_move = points_to_move.reverse
    points_to_move.each do |point_to_move|
      map[point_to_move.send(move_method)] = map[point_to_move]
    end
    # Put a space where robot is currently
    map[robot_curr] = '.'
    # Move the robot_curr
    robot_curr = robot_curr.send(move_method)
  end
end


# Boxes are all moved, calculate final sum
total = 0
map.each do |point, char|
  if char == 'O'
    total += point.y * 100 + point.x
  end
end

puts total