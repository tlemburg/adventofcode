#!/usr/bin/env ruby

test = ARGV[0] == '--test'

in_file = test ? 'test_in.txt' : 'real_in.txt'

lines = []

File.readlines(in_file, chomp: true).each do |line|
  lines << line
end

last = nil
count = 0
(0...lines.count-2).each do |i|
  curr = lines[i].to_i + lines[i+1].to_i + lines[i+2].to_i
  if !last.nil? && curr > last
    count += 1
  end
  last = curr
end

puts count
