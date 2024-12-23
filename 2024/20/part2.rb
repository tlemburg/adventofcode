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

# Need to do a BFS to see how long the best route is, so we know what we are comparing to.
best_base_route_length = nil
start_point = map.select do |point, char|
  char == 'S'
end.to_a.first.first

queue = [[start_point, Set[], 0]]
while queue.any?
  point, visited, dist = queue.shift

  if map[point] == 'E'
    best_base_route_length = dist
    break
  end

  point.neighbors.each do |neighbor|
    if (map[neighbor] == 'E' || map[neighbor] == '.') && !visited.include?(neighbor)
      new_visited = visited.clone
      new_visited << point
      queue << [neighbor, new_visited, dist + 1]
    end
  end

end

puts best_base_route_length

# Do two Djiksta's, one from the start and one from the end. 
# 
# Consider
# ##########################
# #E#....S.................#
# #.######################.#
# #........................#
# ##########################
base_queue = []
distances_from_start = {}
distances_from_end = {}
(0..x_max).each do |x|
  (0..y_max).each do |y|
    point = Point.new(x,y)
    

    if map[point] == '.'
      distances_from_end[point] = Float::INFINITY
      distances_from_start[point] = Float::INFINITY
      base_queue << point
    elsif map[point] == 'S'
      distances_from_start[point] = 0
      distances_from_end[point] = Float::INFINITY
      base_queue << point
    elsif map[point] == 'E'
      distances_from_start[point] = Float::INFINITY
      distances_from_end[point] = 0
      base_queue << point
    end
  end
end

queue = base_queue.clone

until queue.empty?
  queue = queue.sort_by do |point|
    distances_from_start[point]
  end
  point = queue.shift

  point.neighbors.each do |neighbor|
    if queue.include?(neighbor)
      alt = distances_from_start[point] + 1
      if alt < distances_from_start[neighbor]
        distances_from_start[neighbor] = alt
      end
    end
  end
end
puts "Djikstra from start complete"


queue = base_queue.clone

until queue.empty?
  queue = queue.sort_by do |point|
    distances_from_end[point]
  end
  point = queue.shift

  point.neighbors.each do |neighbor|
    if queue.include?(neighbor)
      alt = distances_from_end[point] + 1
      if alt < distances_from_end[neighbor]
        distances_from_end[neighbor] = alt
      end
    end
  end
end
puts "Djikstra from end complete"

# Now examine the potential cheats.
# For each one, confirm that the direction of the cheat makes sense (goes from further from the end to closer)
# and calculate the # of moves it saves, save this number

cheats = []

## cheats
(0..y_max).each do |y|
  (0..x_max).each do |x|
    point1 = Point.new(x,y)
    if %w[S . E].include?(map[point1])
      puts "Scanning from #{point1}"
      (0..x_max).each do |x3|
        (0..y_max).each do |y3|
          point3 = Point.new(x3,y3)
          if point1.manhattan(point3) <= 20 && %w[S . E].include?(map[point3]) 
            if distances_from_start[point1] <= distances_from_start[point3] && distances_from_end[point3] <= distances_from_end[point1]
              # Cheat is good from point1 -> point3
              cheats << best_base_route_length - (distances_from_start[point1] + distances_from_end[point3] + point1.manhattan(point3))
            end
          end
        end
      end

    end
  end
end

puts cheats.sort.tally.inspect
puts cheats.select {|cheat| cheat >= 100}.count