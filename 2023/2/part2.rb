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

  fewest = {
    red: 0,
    blue: 0,
    green: 0
  }

  showings.each do |showing|
    num_colors = showing.split(',').map(&:strip)
    num_colors.each do |num_color|
      num, color = num_color.split(' ')
      num = num.to_i
      case color
      when 'blue'
        fewest[:blue] = num if num > fewest[:blue]
      when 'green'
        fewest[:green] = num if num > fewest[:green]
      when 'red'
        fewest[:red] = num if num > fewest[:red]
      else
        raise 'wtf'
      end
    end
  end

  count += fewest.values.reduce(&:*)
end

puts count