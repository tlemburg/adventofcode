#!/usr/bin/env ruby

require_relative '../../point'
require 'set'

test = ARGV[0] == '--test'

in_file = test ? 'test_in.txt' : 'real_in.txt'

lines = []
 
File.readlines(in_file, chomp: true).each_with_index do |line, y|
  lines << line
end

locks = []
keys = []

lines.each_slice(8) do |lineset|
  if lineset[0] == '#####'
    # lock
    lock = []
    (0..4).each do |i|
      (1..6).each do |j|
        if lineset[j][i] == '.'
          lock << j-1
          break
        end
      end
    end
    locks << lock
  else
    #key
    key = []
    (0..4).each do |i|
      (1..6).each do |j|
        if lineset[j][i] == '#'
          key << 6 - j
          break
        end
      end
    end
    keys << key
  end
end

total = 0

locks.each do |lock|
  keys.each do |key|
    total += 1 if (0..4).all? do |i|
      lock[i] + key[i] <= 5
    end
  end
end 

puts total