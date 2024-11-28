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

energized = Set[] # of points
handled_beams = Set[] # of points and directions

beam_queue = [{dir: :right, point: Point.new(0,0)}]

until beam_queue.empty?
  beam = beam_queue.shift

  energized << beam[:point]
  handled_beams << beam
  
  point = beam[:point]
  new_beams = case map[point]
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

  new_beams.each do |new_beam|
    if (0..x_max).include?(new_beam[:point].x) && (0..y_max).include?(new_beam[:point].y) && !handled_beams.include?(new_beam)
      beam_queue << new_beam
    end
  end
end

puts energized.count