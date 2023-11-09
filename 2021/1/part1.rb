#!/usr/bin/env ruby

test = ARGV[0] == '--test'

in_file = test ? 'test_in.txt' : 'real_in.txt'

curr = nil
count = 0

File.readlines(in_file, chomp: true).each do |line|
  if curr != nil && line.to_i > curr
    count += 1
  end
  curr = line.to_i
end

puts count
