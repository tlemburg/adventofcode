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

line.split(", ").each do |dir|
  turn = dir[0]
  move = dir[1..-1].to_i

  case [facing, turn]
  when ['n', 'R'], ['s', 'L']
    facing = 'e'
    x += move
  when ['n', 'L'], ['s', 'R']
    facing = 'w'
    x -= move
  when ['e', 'R'], ['w', 'L']
    facing = 's'
    y -= move
  when ['e', 'L'], ['w', 'R']
    facing = 'n'
    y += move
  else
    raise 'oh no'
  end
end

puts x.abs + y.abs
