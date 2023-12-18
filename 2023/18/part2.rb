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
map = Set[start]
current = start

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

  puts dir, move
end