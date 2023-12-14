#!/usr/bin/env ruby

require_relative '../../point'

test = ARGV[0] == '--test'

in_file = test ? 'test_in.txt' : 'real_in.txt'

lines = []
map = {}
 
File.readlines(in_file, chomp: true).each_with_index do |line, y|
  lines << line
  line.chars.each_with_index do |char, x|
    map[Point.new(x,y)] = char
  end
end

total = 0

patterns = lines.chunk do |line|
  line.empty?
end.reject do |empty, array|
  empty
end.map do |empty, array|
  array
end

patterns.each do |lines|
  horiz_hash = {}
  
  lines.each_with_index do |line, y|
    horiz_hash[line] ||= []
    horiz_hash[line] << y
  end
  # create another hash of y -> matching y's
  y_hash = {}
  horiz_hash.values.each do |array|
    array.each do |y|
      y_hash[y] = array
    end
  end
  reflection_found = false

  puts y_hash.inspect

  (0...lines.count).each do |y|
    arr = y_hash.fetch(y)
    if arr.include?(y+1)
      # possible horiz reflection
      good_reflection = true
      y_up = y - 1
      y_down = y + 1 + 1
      until (y_up < 0 || y_down >= lines.count)
        if y_hash.fetch(y_up).include?(y_down)
          y_up -= 1
          y_down += 1
        else
          good_reflection = false
          break
        end
      end

      if good_reflection
        reflection_found = y
      end
    end
  end

  puts 'horiz_reflection'
  puts reflection_found

  # If reflection found, add number to total
  total += 100 * (reflection_found+1) and next if reflection_found

  vert_hash = {}

  (0...lines[0].length).each do |x|
    vert_line = []
    lines.each do |line|
      vert_line << line[x]
    end
    vert_line = vert_line.join('')
    vert_hash[vert_line] ||= []
    vert_hash[vert_line] << x
  end

  # create another hash of x -> matching x's
  x_hash = {}
  vert_hash.values.each do |array|
    array.each do |x|
      x_hash[x] = array
    end
  end
  reflection_found = false

  puts x_hash.inspect

  (0...lines[0].length).each do |x|
    arr = x_hash.fetch(x)
    if arr.include?(x+1)
      # possible vert reflection
      good_reflection = true
      x_left = x - 1
      x_right = x + 1 + 1
      until (x_left < 0 || x_right >= lines[0].length)
        if x_hash.fetch(x_left).include?(x_right)
          x_left -= 1
          x_right += 1
        else
          good_reflection = false
          break
        end
      end

      if good_reflection
        reflection_found = x
      end
    end
  end

  total += (reflection_found+1) if reflection_found

  puts 'vert_reflection'
  puts reflection_found

  raise 'huh?' unless reflection_found

end




puts total