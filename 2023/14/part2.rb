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
$y_max = lines.count - 1
$x_max = lines[0].length - 1

class RockMap
  attr_reader :x_max, :y_max, :map

  def initialize(map)
    @map = map
    @known_solutions = {up: {}, left: {}, right: {}, down: {}}
    @x_max = $x_max
    @y_max = $y_max
  end

  def shift_up
    if @known_solutions[:up].keys.include?(@map.hash)
      @map = @known_solutions[:up].fetch(@map.hash)
      puts 'up repeated'
      return
    end

    old_map = @map.dup

    (0..y_max).each do |y|
      # for each line, move all rocks north in that line
      # and then all the lines above it
      (0..y).to_a.reverse.each do |this_y|
        (0..x_max).each do |x|
          point = Point.new(x, this_y)
          if @map[point] == 'O' && @map[point.my] == '.'
            @map[point.my] = 'O'
            @map[point] = '.'
          end
        end
      end
    end

    @known_solutions[:up][old_map.hash] = @map
  end

  def shift_left
    if @known_solutions[:left].keys.include?(@map.hash)
      @map = @known_solutions[:left].fetch(@map.hash)
      puts 'left repeated'
      return
    end

    old_map = @map.dup

    (0..x_max).each do |x|
      # for each line, move all rocks west in that line
      # and then all the lines to the left of it
      (0..x).to_a.reverse.each do |this_x|
        (0..y_max).each do |y|
          point = Point.new(this_x, y)
          if @map[point] == 'O' && @map[point.mx] == '.'
            @map[point.mx] = 'O'
            @map[point] = '.'
          end
        end
      end
    end

    @known_solutions[:left][old_map.hash] = @map
  end

  def shift_down
    if @known_solutions[:down].keys.include?(@map.hash)
      @map = @known_solutions[:down].fetch(@map.hash)
      puts 'down repeated'
      return
    end

    old_map = @map.dup

    (0..y_max).to_a.reverse.each do |y|
      # for each line, move all rocks south in that line
      # and then all the lines below it
      (y..y_max).to_a.each do |this_y|
        (0..x_max).each do |x|
          point = Point.new(x, this_y)
          if @map[point] == 'O' && @map[point.py] == '.'
            @map[point.py] = 'O'
            @map[point] = '.'
          end
        end
      end
    end

    @known_solutions[:down][old_map.hash] = @map
  end

  def shift_right
    if @known_solutions[:right].keys.include?(@map.hash)
      @map = @known_solutions[:right].fetch(@map.hash)
      return
    end

    old_map = @map.dup

    (0..x_max).to_a.reverse.each do |x|
      # for each line, move all rocks east in that line
      # and then all the lines to the right of it
      (x..x_max).to_a.each do |this_x|
        (0..y_max).each do |y|
          point = Point.new(this_x, y)
          if @map[point] == 'O' && @map[point.px] == '.'
            @map[point.px] = 'O'
            @map[point] = '.'
          end
        end
      end
    end

    @known_solutions[:right][old_map.hash] = @map
  end
end


rockmap = RockMap.new(map)

cycles = 1000000000
cycles = 1000

cycles.times do |i|
  rockmap.shift_up
  rockmap.shift_left
  rockmap.shift_down
  rockmap.shift_right
end

total = rockmap.map.select do |point, value|
  value == 'O'
end.keys.map do |point|
  $y_max + 1 - point.y
end.inject(&:+)

puts total