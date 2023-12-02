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
  possible = true
  game_num = line.split(':').first.split(' ').last.to_i
  showings = line.split(':').last.strip.split(';')

  showings.each do |showing|
    num_colors = showing.split(',').map(&:strip)
    num_colors.each do |num_color|
      num, color = num_color.split(' ')
      num = num.to_i
      case color
      when 'blue'
        if num > 14
          possible = false
        end
      when 'green'
        if num > 13
          possible = false
        end
      when 'red'
        if num > 12
          possible = false
        end
      else
        raise 'wtf'
      end
    end
  end

  count += game_num if possible
end

puts count