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

start_point = map.select do |point, val|
  val == 'S'
end.keys.first
end_point = map.select do |point, val|
  val == 'E'
end.keys.first


State = Struct.new(:point, :direction)

visited = Set[]

map[start_point] = '.'
map[end_point] = '.'

queue = []
distances = {}

map.keys.each do |point|
  %i[east west north south].each do |dir|
    state = State.new(point, dir)
    distances[state] = 1000000000000
    queue << state
  end
end

distances[State.new(start_point, :east)] = 0

until queue.empty?
  queue.sort_by! do |state|
    distances[state]
  end

  state = queue.shift
  
  curr_dist = distances[state]
  puts state
  puts curr_dist

  if state.point == end_point
    puts "FINAL:"
    puts distances[state]
    exit
  end

  new_state = state.dup
  case new_state.direction
  when :east
    new_state.point = new_state.point.px
  when :west
    new_state.point = new_state.point.mx
  when :north
    new_state.point = new_state.point.my
  when :south
    new_state.point = new_state.point.py
  end
  if map[new_state.point] == '.'
    if queue.include?(new_state) && curr_dist + 1 < distances[new_state]
      distances[new_state] = curr_dist + 1
    end
  end

  # only try to turn a certain direction if maze is open that way. And also,
  # if we haven't visit

  new_state = state.dup
  case new_state.direction
  when :east, :west
    new_state.direction = :north
    if map[new_state.point.my] == '.' && queue.include?(new_state) && curr_dist + 1000 < distances[new_state]
      distances[new_state] = curr_dist + 1000
    end
    new_state.direction = :south
    if map[new_state.point.py] == '.' && queue.include?(new_state) && curr_dist + 1000 < distances[new_state]
      distances[new_state] = curr_dist + 1000
    end
  when :south, :north
    new_state.direction = :east
    if map[new_state.point.px] == '.' && queue.include?(new_state) && curr_dist + 1000 < distances[new_state]
      distances[new_state] = curr_dist + 1000
    end
    new_state.direction = :west
    if map[new_state.point.mx] == '.' && queue.include?(new_state) && curr_dist + 1000 < distances[new_state]
      distances[new_state] = curr_dist + 1000
    end
  end

end

puts "Not found"