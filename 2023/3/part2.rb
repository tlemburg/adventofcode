#!/usr/bin/env ruby

require_relative '../../point'

test = ARGV[0] == '--test'

in_file = test ? 'test_in.txt' : 'real_in.txt'

$lines = []
 
File.readlines(in_file, chomp: true).each do |line|
  $lines << line
end

numbers = []
gears = []

diagram = {}

$lines.each_with_index do |line, y|
  # find part numbers with line and index

  current_num = nil
  line.chars.each_with_index do |char, x|
    if ('0'..'9').include?(char)
      if current_num
        current_num << char
      else
        current_num = [char]
      end
    else
      if current_num
        numbers << {
          number: current_num.join('').to_i,
          loc: (1..current_num.length).to_a.map { |i| Point.new(x - i, y) }
        }
        current_num = nil
      end
      if char == '*'
        gears << Point.new(x, y)
      end
    end
  end

  if current_num
    numbers << {
      number: current_num.join('').to_i,
      loc: (1..current_num.length).to_a.map { |i| Point.new($lines[0].length - i, y) }
    }
    current_num = nil
  end

end

numbers.each do |number|
  number[:loc].each do |point|
    diagram[point] = number
  end
end

result = 0



gears.each do |gear|
  # gear is a point

  found_numbers = {}

  [gear.px, gear.px.py, gear.py, gear.mx.py, gear.mx, gear.mx.my, gear.my, gear.my.px].each do |new_point|

    if diagram.key?(new_point)
      found_numbers[diagram[new_point]] = true
    end
  end

  if found_numbers.keys.count == 2
    result += found_numbers.keys.map { |number| number[:number] }.reduce(&:*)
  end
end

puts result