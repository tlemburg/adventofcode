#!/usr/bin/env ruby

test = ARGV[0] == '--test'

in_file = test ? 'test_in.txt' : 'real_in.txt'

lines = []
 
File.readlines(in_file, chomp: true).each do |line|
  lines << line
end

final = 1

[1,3,5,7].each do |slope|
count = 0


lines[1..-1].each_with_index do |line, i|
  col = ((i+1) * slope) % line.length
  count += 1 if line[col] == '#'
end

final *= count

end

count = 0
slope = 1
lines[1..-1].each_with_index do |line, i|
  next if i % 2 == 0
  

  col = ((i+1)/2 * slope) % line.length
  count += 1 if line[col] == '#'

end

final *= count
puts final
