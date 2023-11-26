#!/usr/bin/env ruby

require_relative '../../point'

test = ARGV[0] == '--test'

in_file = test ? 'test_in.txt' : 'real_in.txt'

lines = []
 
File.readlines(in_file, chomp: true).each do |line|
  lines << line
end

arr = Array.new

1000.times do
  arr.push Array.new(1000, 0)
end

lines.each do |line|
  if line.start_with?('turn on')
    row_start, col_start = line.split(' ')[2].split(',').map(&:to_i)
    row_end, col_end = line.split(' ').last.split(',').map(&:to_i)


    (row_start..row_end).each do |row|
      (col_start..col_end).each do |col|
        arr[row][col] = 1
      end
    end

  elsif line.start_with?('turn off')
    row_start, col_start = line.split(' ')[2].split(',').map(&:to_i)
    row_end, col_end = line.split(' ').last.split(',').map(&:to_i)
    
    (row_start..row_end).each do |row|
      (col_start..col_end).each do |col|
        arr[row][col] = 0
      end
    end
  else
    row_start, col_start = line.split(' ')[1].split(',').map(&:to_i)
    row_end, col_end = line.split(' ').last.split(',').map(&:to_i)


    (row_start..row_end).each do |row|
      (col_start..col_end).each do |col|
        curr = arr[row][col]
        arr[row][col] = (curr == 1 ? 0 : 1)
      end
    end
  end
end

count = 0
other_count = 0
arr.each do |inner|
  inner.each do |el|
    other_count += 1
    count += 1 if el == 1
  end
end

puts count
puts other_count
