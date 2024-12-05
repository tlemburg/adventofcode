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

gap_hit = false

orderings = {}
updates = []

lines.each do |line|
  if line == ''
    gap_hit = true
    next
  end

  if !gap_hit
    before, after = line.split('|').map(&:to_i)
    orderings[before] ||= []
    orderings[before] << after
  else
    updates << line.split(',').map(&:to_i)
  end
end

total = 0

failures = []

updates.each do |update|
  failed = false
  update.each_with_index do |num, i|
    next if i == 0

    if (update[0..i] & orderings.fetch(num, [])).any?
      failed = true
      break
    end
  end


  if failed
    failures << update
  end
end

failures.each do |update|

  puts "Failure:"
  puts update.inspect

  failing = true
  while failing
    failing = false
    puts update.inspect

    update.each_with_index do |num, i|
      next if i == 0
  
      borked = false
      (0..(i-1)).to_a.each do |j|
        puts j
        if orderings.fetch(num, []).include?(update[j])
          # Number at i needs to go right before j
          puts "Ordering found: #{num} | #{update[j]}"
          
          update.delete_at(i)

          update = (j == 0 ? [] : update[0..(j-1)]) + [num] + update[j..-1]
          puts update.inspect

          borked = true
          failing = true
          break
        end
      end

      break if borked
    end
  end 

  total += update[(update.count-1) / 2]
end

puts total