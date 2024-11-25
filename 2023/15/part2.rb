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

line = lines.first

instructions = line.split(',')

boxes = [[]] * 256

instructions.each do |instruction|
  match = instruction.match(/\A(?<label>[a-z]+)(?<inst>[-,=])(?<digit>\d+)\z/)

  label = match[:label]
  current_value = 0
  label.chars.each do |char|
    current_value += char.ord
    current_value *= 17
    current_value %= 256
  end
  box = current_value

  if match[:inst] == '='
    found = false
  elsif match[:inst] == '-'

  else
    raise 'invalid inst'
  end


end
