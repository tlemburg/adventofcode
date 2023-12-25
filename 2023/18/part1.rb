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

map = []

start = Point.new(0,0)
map = Set[start]
current = start

lines.each do |line|
  dir, move, color = line.split(' ')
  move = move.to_i
  case dir
  when 'R'
    move.times do |i|
      map << current.px(i+1)
    end
    current = current.px(move)
  when 'L'
    move.times do |i|
      map << current.mx(i+1)
    end
    current = current.mx(move)
  when 'U'
    move.times do |i|
      map << current.my(i+1)
    end
    current = current.my(move)
  when 'D'
    move.times do |i|
      map << current.py(i+1)
    end
    current = current.py(move)
  else
    raise 'wtf'
  end
end

x_min = map.min do |a,b|
  a.x <=> b.x
end.x
x_max = map.max do |a,b|
  a.x <=> b.x
end.x
y_min = map.min do |a,b|
  a.y <=> b.y
end.y
y_max = map.max do |a,b|
  a.y <=> b.y
end.y


known_empty = Set[]

points_checked = 0

puts (y_min..y_max).inspect
puts (x_min..x_max).inspect

(y_min..y_max).each do |y|
  puts "checking #{y}"
  (x_min..x_max).each do |x|
    next if map.include?(Point.new(x,y))
    next if known_empty.include?(Point.new(x,y))

    # Start a DFS here and try to get to the edges, not running into a trench
    # if you do, these points are all nulls
    # if you can't add all these points to the map

    curr_array = Set[Point.new(x,y)]
    checked = Set[]
    queue = [Point.new(x,y)]
    edge_found = false
    until queue.empty?
      point = queue.shift
      next if checked.include?(point)

      checked << point
      points_checked += 1
      puts points_checked if points_checked % 10000 == 0
      #puts point

      [point.px, point.py, point.mx, point.my].each do |new_point|
        if !curr_array.include?(new_point) && !map.include?(new_point)
          # is this point at the edge
          if known_empty.include?(new_point) || new_point.x > x_max || new_point.x < x_min || new_point.y > y_max || new_point.y < y_min
            # out of bounds
            edge_found = true
          else
            # this point is valid
            curr_array << new_point
            queue << new_point
          end
        else
          # don't use this new point
        end
      end
    end

    if edge_found
      known_empty = known_empty + curr_array
    else
      # we didn't hit the edge
      # all these points go on the map
      map = map + curr_array
    end
  end

end

puts map.count

