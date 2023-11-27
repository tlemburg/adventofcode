#!/usr/bin/env ruby

require_relative '../../point'

test = ARGV[0] == '--test'

in_file = test ? 'test_in.txt' : 'real_in.txt'

lines = []
 
File.readlines(in_file, chomp: true).each do |line|
  lines << line
end

line = lines.first

facing = 'n'
x = 0
y = 0

spot_hash = {
  Point.new(0,0) => true
}

line.split(", ").each do |dir|
  turn = dir[0]
  move = dir[1..-1].to_i

  case [facing, turn]
  when ['n', 'R'], ['s', 'L']
    facing = 'e'
    move.times do |i|
      x += 1
      if spot_hash.key?(Point.new(x,y))
        puts x.abs + y.abs
        exit
      end
      spot_hash[Point.new(x,y)] = true
    end
  when ['n', 'L'], ['s', 'R']
    facing = 'w'
    move.times do |i|
      x -= 1
      if spot_hash.key?(Point.new(x,y))
        puts x.abs + y.abs
        exit
      end
      spot_hash[Point.new(x,y)] = true
    end
  when ['e', 'R'], ['w', 'L']
    facing = 's'
    move.times do |i|
      y += 1
      if spot_hash.key?(Point.new(x,y))
        puts x.abs + y.abs
        exit
      end
      spot_hash[Point.new(x,y)] = true
    end
  when ['e', 'L'], ['w', 'R']
    facing = 'n'
    move.times do |i|
      y -= 1
      if spot_hash.key?(Point.new(x,y))
        puts x.abs + y.abs
        exit
      end
      spot_hash[Point.new(x,y)] = true
    end
  else
    raise 'oh no'
  end
end

puts x.abs + y.abs
