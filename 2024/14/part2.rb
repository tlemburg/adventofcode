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

width = 101
height = 103

bots = []

lines.each do |line|
  regex = /\Ap=(?<px>\d+),(?<py>\d+) v=(?<vx>-?\d+),(?<vy>-?\d+)\z/
  match = line.match(regex)
  px = match[:px].to_i
  py = match[:py].to_i
  vx = match[:vx].to_i
  vy = match[:vy].to_i

  bots << {
    point: Point.new(px, py),
    vx:,
    vy:
  }
end

10000.times do |t|
  next if t < 1500
  File.open(File.join(__dir__, "#{t}.txt"), 'w+') do |f|

    f.puts "TIME #{t}:"
    
    set = Set[]
    bots.each do |bot|
      set << Point.new(
        (bot.fetch(:point).x + bot.fetch(:vx) * t) % width,
        (bot.fetch(:point).y + bot.fetch(:vy) * t) % height
      )
    end

    height.times do |y|
      string = (0...width).map do |x|
        set.include?(Point.new(x,y)) ? '#' : ' '
      end.join
      f.puts string
    end

    f.puts '------------------'
    sleep(1)
  end
end