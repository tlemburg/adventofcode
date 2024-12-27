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

total = 0

lines[2..-1].each do |line|
  reached = Set[0]
  curr = 0
  while (curr < line.length)
    if reached.include?(curr)
      # Check all towels that fit here, for each, add a new reached
      towels.each do |towel|
        if towel == line[curr...(curr+towel.length)]
          reached << curr + towel.length
        end
      end
    end
    curr += 1
  end

  total += 1 if reached.include?(line.length)
end

puts total