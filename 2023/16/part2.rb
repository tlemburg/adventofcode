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

x_max = lines[0].length - 1
y_max = lines.count - 1

beam_to_output = {}
best_energized = 0

starting_beams = [{dir: :right, point: Point.new(0,0)}]
starting_beams = (0..y_max).map do |y|
  [{dir: :right, point: Point.new(0, y)}, {dir: :left, point: Point.new(x_max, y)}]
end.inject(&:+) + (0..x_max).map do |x|
  [{dir: :down, point: Point.new(x, 0)}, {dir: :up, point: Point.new(x, y_max)}]
end.inject(&:+)

# Starting here with trying each outside point
starting_beams.each do |starting_beam|
  
  energized = Set[] # of points
  handled_beams = Set[] # of points and directions

  beam_queue = [starting_beam]

  until beam_queue.empty?
    beam = beam_queue.shift

    energized << beam[:point]
    handled_beams << beam

    new_beams = if beam_to_output.key?(beam)
      beam_to_output.fetch(beam)
    else
      point = beam[:point]
      case map[point]
      when '.'
        case beam[:dir]
        when :right
          [{dir: :right, point: point.px}]
        when :left
          [{dir: :left, point: point.mx}]
        when :up
          [{dir: :up, point: point.my}]
        when :down
          [{dir: :down, point: point.py}]
        end
      when '|'
        case beam[:dir]
        when :left, :right
          [{dir: :up, point: point.my}, {dir: :down, point: point.py}]
        when :up
          [{dir: :up, point: point.my}]
        when :down
          [{dir: :down, point: point.py}]
        end
      when '-'
        case beam[:dir]
        when :up, :down
          [{dir: :left, point: point.mx}, {dir: :right, point: point.px}]
        when :left
          [{dir: :left, point: point.mx}]
        when :right
          [{dir: :right, point: point.px}]
        end
      when '/'
        case beam[:dir]
        when :up
          [{dir: :right, point: point.px}]
        when :down
          [{dir: :left, point: point.mx}]
        when :left
          [{dir: :down, point: point.py}]
        when :right
          [{dir: :up, point: point.my}]
        end
      when '\\'
        case beam[:dir]
        when :down
          [{dir: :right, point: point.px}]
        when :up
          [{dir: :left, point: point.mx}]
        when :right
          [{dir: :down, point: point.py}]
        when :left
          [{dir: :up, point: point.my}]
        end
      end
    end
    
    beam_to_output[beam] = new_beams

    new_beams.each do |new_beam|
      if (0..x_max).include?(new_beam[:point].x) && (0..y_max).include?(new_beam[:point].y) && !handled_beams.include?(new_beam)
        beam_queue << new_beam
      end
    end
  end

  best_energized = energized.count if energized.count > best_energized

end

puts best_energized