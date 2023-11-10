#!/usr/bin/env ruby

test = ARGV[0] == '--test'

in_file = test ? 'test_in.txt' : 'real_in.txt'

lines = []
 
File.readlines(in_file, chomp: true).each do |line|
  lines << line
end

lines.each do |line|
  lines.each do |line2|
    next if line == line2
    if line.to_i + line2.to_i == 2020
      puts line.to_i * line2.to_i
      exit
    end
  end
end
