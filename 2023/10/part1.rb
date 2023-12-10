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

curr = start_point
next_point = if ['F', '7', '|'].include?(map[curr.my])
  curr.my
elsif ['F', 'L', '-'].include?(map[curr.mx])
  curr.mx
elsif ['L', '|', 'J'].include?(map[curr.py])
  curr.py
else
  curr.px
end

count = 0

loop do
  puts 'CURR'
  puts curr.to_s
  puts 'NEXT POINT'
  puts next_point.to_s
  old_curr = curr.dup
  puts 'OLD CURR'
  puts old_curr.to_s
  puts '----'
  curr = next_point
  count += 1

  break if map[curr] == 'S'

  puts 'MAP CURR'
  puts map[curr]
  puts '****'
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

puts (count / 2.0).ceil