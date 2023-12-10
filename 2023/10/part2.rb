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

start_point = map.select do |key, value|
  value == 'S'
end.keys.first

curr = start_point.dup
up = false
down = false
left = false
right = false

if ['F', '7', '|'].include?(map[curr.my])
  next_point = curr.my
  up = true
end
if ['F', 'L', '-'].include?(map[curr.mx])
  next_point = curr.mx
  left = true
end
if ['L', '|', 'J'].include?(map[curr.py])
  next_point = curr.py
  down = true
end
if ['J', '7', '-'].include?(map[curr.px])
  next_point = curr.px
  right = true
end

path = {curr: true}

loop do
  old_curr = curr.dup
  curr = next_point
  path[curr] = true

  break if map[curr] == 'S'

  if old_curr == curr.my
    # moved down
    if map[curr] == 'L'
      next_point = curr.px
    elsif map[curr] == 'J'
      next_point = curr.mx
    elsif map[curr] == '|'
      next_point = curr.py
    else
      raise 'wft down'
    end
  elsif old_curr == curr.mx
    # moved right
    if map[curr] == '-'
      next_point = curr.px
    elsif map[curr] == 'J'
      next_point = curr.my
    elsif map[curr] == '7'
      next_point = curr.py
    else
      raise 'wft right'
    end
  elsif old_curr == curr.py
    # moved up
    if map[curr] == '7'
      next_point = curr.mx
    elsif map[curr] == 'F'
      next_point = curr.px
    elsif map[curr] == '|'
      next_point = curr.my
    else
      raise 'wft up'
    end
  else
    # moved left
    if map[curr] == 'L'
      next_point = curr.my
    elsif map[curr] == '-'
      next_point = curr.mx
    elsif map[curr] == 'F'
      next_point = curr.py
    else
      raise 'wft left'
    end
  end

end

if up && down
  map[start_point] = '|'
elsif up && left
  map[start_point] = 'J'
elsif up && right
  map[start_point] = 'L'
elsif left && right
  map[start_point] = '-'
elsif left && down
  map[start_point] = '7'
elsif right && down
  map[start_point] = 'F'
else
  raise 'nope'
end

width = lines[0].length
height = lines.count

cells = 0

(0...height).each do |y|
  paths_crossed = 0
  path_left_side = nil
  (0...width).each do |x|
    point = Point.new(x,y)
    if path.key?(point)
      if map[point] == '|'
        paths_crossed += 1
      elsif map[point] == 'L'
        if path_left_side.nil?
          path_left_side = 'L'
        else
          raise 'OK L Is weird'
        end
      elsif map[point] == 'J'
        if path_left_side == 'L'
          path_left_side = nil
        elsif path_left_side == 'F'
          paths_crossed += 1
          path_left_side = nil
        else
          raise 'OK J is weird'
        end
      elsif map[point] == 'F'
        if path_left_side.nil?
          path_left_side = 'F'
        else
          raise 'OK F Is weird'
        end
      elsif map[point] == '7'
        if path_left_side == 'F'
          path_left_side = nil
        elsif path_left_side == 'L'
          paths_crossed += 1
          path_left_side = nil
        else
          raise 'OK 7 is weird'
        end
      end
    else
      if paths_crossed.odd?
        cells += 1
      end
    end
  end
end

puts cells