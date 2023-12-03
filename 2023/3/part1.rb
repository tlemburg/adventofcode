#!/usr/bin/env ruby

require_relative '../../point'

test = ARGV[0] == '--test'

in_file = test ? 'test_in.txt' : 'real_in.txt'

$lines = []
 
File.readlines(in_file, chomp: true).each do |line|
  $lines << line
end

numbers = []

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
          length: current_num.length,
          loc: Point.new(x - current_num.length, y)
        }
        current_num = nil
      end
    end
  end

  if current_num
    numbers << {
      number: current_num.join('').to_i,
      length: current_num.length,
      loc: Point.new($lines[0].length - current_num.length, y)
    }
    current_num = nil
  end

end

puts numbers.inspect

result = 0
puts_count = 0

def check_point(p2)
  found = false
  if p2.x >= 0 && p2.x < $lines[0].length && p2.y >= 0 && p2.y < $lines.count && $lines[p2.y][p2.x] != '.' && !('0'..'9').include?($lines[p2.y][p2.x])
    found = true
  end
  return found
end

numbers.each do |number|
  found = false
  point = number[:loc]

  p2 = point.mx
  found = true if check_point(p2)

  p2 = point.mx.my
  found = true if check_point(p2)
    
  p2 = point.mx.py
  found = true if check_point(p2)

  (0...number[:length]).each do |i|
    p2 = point.px(i).py
    found = true if check_point(p2)

    p2 = point.px(i).my
    found = true if check_point(p2)
  end

  p2 = point.px(number[:length])
  found = true if check_point(p2)

  p2 = point.px(number[:length]).my
  found = true if check_point(p2)

  p2 = point.px(number[:length]).py
  found = true if check_point(p2)

  puts number if found
  puts_count += 1
  result += number[:number] if found
end

puts result
