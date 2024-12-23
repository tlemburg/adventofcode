#!/usr/bin/env ruby

require_relative '../../point'
require 'set'

test = ARGV[0] == '--test'

in_file = test ? 'test_in.txt' : 'real_in.txt'

lines = []
 
File.readlines(in_file, chomp: true).each_with_index do |line, y|
  lines << line
end

towels = Set[]

lines.first.split(', ').each do |towel|
  towels << towel
end

puts towels.inspect

total = 0

lines[2..-1].each do |line|
  puts line
  current_sets = [[]] # each towelset is an array of the towels used

  until current_sets.empty?
    current_set = current_sets.shift
    puts "Current Set: #{current_set.inspect}"
    start = current_set.map(&:length).sum

    found = false
    (start...line.length).to_a.reverse.each do |i|
      if towels.include?(line[start..i])
        found = true if i == line.length - 1
        current_sets << current_set + [line[start..i]]
        towels << (current_set + [line[start..i]]).join
      end
    end
    if found
      total += 1
      break
    end
  end
end

puts total