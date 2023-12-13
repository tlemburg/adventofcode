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

class PicrossLine
  def initialize(line, numbers)
    @line = line
    @numbers = numbers
  end

  def match?
    @line.split('.').reject(&:empty?).map(&:length) == @numbers
  end
end

def check_line(line, numbers)
  if line.chars.include?('?')
    return check_line(line.sub('?', '.'), numbers) + check_line(line.sub('?', '#'), numbers)
  else
    return PicrossLine.new(line, numbers).match? ? 1 : 0
  end

end

count = 0
lines.each do |line|
  springs, picross = line.split(' ')
  picross = picross.split(',').map(&:to_i)
  value = check_line(springs, picross)
  puts value
  count += value
end

puts count
