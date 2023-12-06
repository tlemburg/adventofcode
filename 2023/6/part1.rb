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

times = lines.first.split(':').last.split(' ').compact.reject(&:empty?).map(&:to_i)
distances = lines.last.split(":").last.split(' ').compact.reject(&:empty?).map(&:to_i)

count = 1

times.each_with_index do |time, i|
  distance = distances[i]

  this_count = 0
  (0..time).to_a.each do |hold_time|
    speed = hold_time
    if speed * (time - hold_time) > distance
      this_count += 1
    end

  end

  count *= this_count

end

puts count