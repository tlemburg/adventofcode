#!/usr/bin/env ruby

require_relative '../../point'
require 'set'

test = ARGV[0] == '--test'

in_file = test ? 'test_in.txt' : 'real_in.txt'

lines = []
map = {}
 
File.readlines(in_file, chomp: true).each_with_index do |line, y|
  lines << line
end

$x_max = test ? 6 : 70
$y_max = test ? 6 : 70
falling_bytes = test ? 12 : 1024

lines.first(falling_bytes).each do |line|
  x, y = line.split(',').map(&:to_i)
  map[Point.new(x,y)] = '#'
end

def djikstra(map)
  map = map.clone
  ## Dijkstra's
  distances = {}
  prev = {}
  queue = []
  (0..$x_max).each do |x|
    (0..$y_max).each do |y|
      point = Point.new(x,y)
      queue << point
      distances[point] = Float::INFINITY
    end
  end

  distances[Point.new(0,0)] = 0

  until queue.empty?
    queue.sort_by! do |point|
      distances.fetch(point)
    end

    curr = queue.shift
    if curr.x == $x_max && curr.y == $y_max
      puts "DONE"
      puts distances.fetch(curr)

      path = [curr]

      if distances[curr] == Float::INFINITY
        path = "NO PATH"
      else
        until curr == Point.new(0,0)
          path.unshift prev.fetch(curr)
          curr = prev.fetch(curr)
        end
      end

      return {
        distances:,
        path:
      }
    end

    [curr.px, curr.py, curr.mx, curr.my].each do |next_point|
      if queue.include?(next_point) && map[next_point] != '#'
        dist = distances.fetch(curr) + 1
        if dist < distances.fetch(next_point)
          distances[next_point] = dist
          prev[next_point] = curr
        end
      end
    end
  end

  return {
    distances:,
    path: "NO PATH"
  }

end

curr_line = falling_bytes

curr_result = djikstra(map)

until curr_line >= lines.count
  # Drop the next byte
  x,y = lines[curr_line].split(',').map(&:to_i)
  point = Point.new(x,y)
  puts "Dropping #{point}"
  map[point] = '#'

  if curr_result.fetch(:path).include?(point)
    # need to re-djikstra
    curr_result = djikstra(map)
    if curr_result.fetch(:path) == "NO PATH"
      puts "DONE 2"
      puts point
      exit
    end
  end
  curr_line += 1
end

puts "um not found"