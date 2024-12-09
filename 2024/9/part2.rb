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

files = {}

space = false
counter = 0
curr_index = 0
spaces = {}

final_disk = []

lines[0].chars.each do |char|
  num = char.to_i
  if space
    spaces[num] ||= []
    spaces[num] << curr_index
  else
    files[counter] = {index: curr_index, length: num}
    counter += 1
  end

  curr_index += num
  space = !space
end

max_space = spaces.keys.max

files.to_a.reverse.each do |counter, arr|
  # Find the earliest space that fits it
  length = arr[:length]

  candidates = {} # the candidate indices for insertion...linked back to their num
  (length..max_space).each do |i|
    spaces.fetch(i, []).each do |index|
      candidates[index] = i
    end
  end

  next if candidates.count == 0

  # find the smallest candidate
  insert_index = candidates.keys.sort.first

  # remove the file and create space where it was.
  # TODO TODO TODO


  # move the file to that candidate
  files[counter][:index] = insert_index



  # eliminate the space that we are consuming
  spaces[candidates[insert_index]].delete(insert_index)

  # if there is remaining space from that space, create a new space
  remaining_space = candidates[insert_index] - files[counter][:length]
  if remaining_space > 0
    spaces[remaining_space] << insert_index + files[counter][:length]
  end
end

files.each do |num, file|
  (0...file.fetch(:length)).each do |i|
    final_disk[file.fetch(:index) + i] = num
  end
end

total = 0

final_disk.each_with_index do |num, i|
  total += num.to_i * i
end

puts total