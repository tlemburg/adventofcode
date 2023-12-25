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
current = start
points = [start]

lines.each do |line|
  dir, move, color = line.split(' ')
  color = color[2..-2]

  dir = case color[-1]
  when '0'
    'R'
  when '1'
    'D'
  when '2'
    'L'
  when '3'
    'U'
  else
    raise 'huh?'
  end

  move = color[0..4].to_i(16)

  case dir
  when 'R'
    #current = current.px(move)
    #points << current
  when 'L'
    #current = current.mx(move)
    #points << current
  when 'D'
    #current = current.py(move)
    #points << current
  when 'U'
    #current = current.my(move)
    #points << current
  else 
    raise 'readlly wtf'
  end

  dir, move, color = line.split(' ')
  move = move.to_i
  case dir
  when 'R'
    current = current.px(move)
    points << current
  when 'L'
    current = current.mx(move)
    points << current
  when 'D'
    current = current.py(move)
    points << current
  when 'U'
    current = current.my(move)
    points << current
  else 
    raise 'readlly wtf'
  end
  
end
points.pop
points.sort_by!(&:y)
grouped_points = points.group_by(&:y)

puts points.inspect

total = 0
current_ranges = []
previous_y = nil

grouped_points.each do |y, points|
  puts '-----'
  puts "y=#{y}"
  puts 'CURRENT RANGES:'
  puts current_ranges.inspect
  old_current_ranges = current_ranges.dup
  points = points.sort_by(&:x)

  # take the current ranges, find this y versus previous y, and multiply and add.
  unless previous_y.nil?
    current_ranges.each do |range|
      total += range.size * (y - previous_y - 1)
    end
  end

  if previous_y.nil?
    total += current_ranges.map(&:size).inject(0, &:+)
  end
  

  points.each_slice(2) do |a, b|
    # does this pair intersect with a current_range (or perhaps two?)
    found_ranges = []
    current_ranges.each do |current_range|
      if a.x < current_range.min && b.x > current_range.max
        raise 'how is the pair bigger than a range?'
      elsif a.x > current_range.min && b.x < current_range.max
        # pair is inside the range, and must delete from it later
        found_ranges << current_range
      elsif a.x == current_range.min || a.x == current_range.max || b.x == current_range.min || b.x == current_range.max
        found_ranges << current_range
      end
    end

    raise 'how do we have 3+ found ranges' if found_ranges.count > 2

    # if not, start it as a new range
    if found_ranges.empty?
      current_ranges << (a.x..b.x)
      total += (a.x..b.x).size
    else
      # if so, the intersection ought to just be one point on each side at most.
      # either add to or subtract from the range
      if found_ranges.count == 2
        found_ranges.sort_by!(&:min)
        if found_ranges.first.max == a.x && b.x == found_ranges.last.min
          # adding to the two ranges
          current_ranges.delete(found_ranges.first)
          current_ranges.delete(found_ranges.last)
          current_ranges << (found_ranges.first.min..found_ranges.last.max)
          total += (found_ranges.first.min..found_ranges.last.max).size
        else
          raise 'ok I dont know how they work'
        end
      else
        # just the one range. # it can either extend on left, subtract on left, subtract on right, or extend on right, or subtract in middle
        range = found_ranges.first
        if b.x == range.min
          # extend left
          current_ranges.delete(range)
          current_ranges << (a.x..range.max)
          total += (a.x..range.max).size
        elsif a.x == range.min
          # shrink left
          current_ranges.delete(range)
          current_ranges << (b.x..range.max)
          total += range.size
        elsif b.x == range.max
          # shrink right
          current_ranges.delete(range)
          current_ranges << (range.min..a.x)
          total += range.size
        elsif a.x == range.max
          # extend right
          current_ranges.delete(range)
          current_ranges << (range.min..b.x)
          total += (range.min..b.x).size
        elsif a.x > range.min && b.x < range.max
          # subtract in middle
          current_ranges.delete(range)
          current_ranges << (range.min..a.x)
          current_ranges << (b.x..range.max)
          total += range.size
        else
          raise 'ok how does THIS Work?'
        end
      end
    end

  end

  

  puts 'NEW CURRENT RANGES:'
  puts current_ranges.inspect

  puts total
  previous_y = y
end

puts total