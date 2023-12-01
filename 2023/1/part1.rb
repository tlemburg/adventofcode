#!/usr/bin/env ruby

require_relative '../../point'

test = ARGV[0] == '--test'

in_file = test ? 'test_in.txt' : 'real_in.txt'

lines = []
 
File.readlines(in_file, chomp: true).each do |line|
  lines << line
end


count = 0
lines.each do |line|
  first = nil
  last = nil

  first_found = false
  line.chars.each do |char|
    puts char
    if /\d/.match(char)
      unless first_found
        first = char.to_i
        first_found = true
      end
      last = char.to_i
    end
  end
  
  count += first * 10 + last
end

puts count