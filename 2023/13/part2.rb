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

class ReflectionFinder
  attr_reader :x_hash, :y_hash
  attr_reader :vert_lines

  def initialize(pattern)
    @pattern = pattern
    @vert_lines = []
  end

  def lines
    @pattern
  end

  def vert_reflection
    vert_hash = {}

    (0...lines[0].length).each do |x|
      vert_line = []
      lines.each do |line|
        vert_line << line[x]
      end
      vert_line = vert_line.join('')
      @vert_lines.push vert_line
      vert_hash[vert_line] ||= []
      vert_hash[vert_line] << x
    end

    # create another hash of x -> matching x's
    @x_hash = {}
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
          break
        end
      end
    end

    puts 'vert_reflection'
    puts reflection_found
    @vert_reflection = reflection_found
  end

  def horiz_reflection
    horiz_hash = {}
  
    lines.each_with_index do |line, y|
      horiz_hash[line] ||= []
      horiz_hash[line] << y
    end
    # create another hash of y -> matching y's
    @y_hash = {}
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
          break
        end
      end
    end

    puts 'horiz_reflection'
    puts reflection_found
    @horiz_reflection = reflection_found
  end

  def find_reflection
    horiz_reflection
    vert_reflection

    find_other_reflection
  end

  def find_other_reflection
    this_total = 0

    @other_horiz = other_horiz_reflection

    if @other_horiz
      this_total += 100 * (@other_horiz + 1)
    end

    @other_vert = other_vert_reflection

    if @other_vert
      this_total += (@other_vert + 1)
    end

    this_total
  end

  def other_horiz_reflection
    current_horiz = @horiz_reflection
    (0...lines.count).each do |y|
      # reflect between y and y+1
      one_miss = false
      (0..y).each do |y2|
        dist_to_reflec = (y - y2)
        match = y+1 + dist_to_reflec
        next if match >= lines.length
        if y_hash.fetch(y2).include?(match)
          # matches
        else
          if one_miss
            # two misses, no good
            one_miss = false
            break
          else
            one_miss = {
              reflect: y,
              y1: y2,
              y2: match
            }
          end
        end
      end

      if one_miss
        # Looking good! Check the strings to ensure that one character is different.
        string1 = lines[one_miss[:y1]].chars
        string2 = lines[one_miss[:y2]].chars

        one_wrong = false
        until string1.empty?
          if string1.shift != string2.shift
            if one_wrong
              # two wrong, so no good
              one_wrong = false
              break
            else
              one_wrong = true
            end
          end
        end

        if one_wrong
          return one_miss.fetch(:reflect)
        end
      end
    end

    return nil
  end

  def other_vert_reflection
    current_vert = @vert_reflection
    (0...lines[0].length).each do |x|
      # reflect between x and x+1
      one_miss = false
      (0..x).each do |x2|
        dist_to_reflec = (x - x2)
        match = x+1 + dist_to_reflec
        next if match >= lines[0].length
        if x_hash.fetch(x2).include?(match)
          # matches
        else
          if one_miss
            # two misses, no good
            one_miss = false
            break
          else
            one_miss = {
              reflect: x,
              x1: x2,
              x2: match
            }
          end
        end
      end

      if one_miss
        # Looking good! Check the strings to ensure that one character is different.
        string1 = vert_lines[one_miss[:x1]].chars
        string2 = vert_lines[one_miss[:x2]].chars

        one_wrong = false
        until string1.empty?
          if string1.shift != string2.shift
            if one_wrong
              # two wrong, so no good
              one_wrong = false
              break
            else
              one_wrong = true
            end
          end
        end

        if one_wrong
          return one_miss.fetch(:reflect)
        end
      end
    end

    return nil
  end
end

patterns.each do |lines|
  total += ReflectionFinder.new(lines).find_reflection
  puts '----------'
end




puts total