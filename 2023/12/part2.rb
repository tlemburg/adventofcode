#!/usr/bin/env ruby

require_relative '../../point'

test = ARGV[0] == '--test'

in_file = test ? 'test_in.txt' : 'real_in.txt'

$lines = []
map = {}
 
File.readlines(in_file, chomp: true).each_with_index do |line, y|
  $lines << line
  line.chars.each_with_index do |char, x|
    map[Point.new(x,y)] = char
  end
end

class PicrossLine
  def initialize(line)
    @line = line
  end

  def known_numbers
    numbers = []
    on_hash = false
    curr = 0
    @line.chars.each do |char|
      if on_hash
        if char == '#'
          curr += 1
        elsif char == '.'
          numbers << curr
          curr = 0
          on_hash = false
        elsif char == '?'
          return numbers
        else
          raise 'wtf if'
        end
      else
        if char == '.'
          # do nothing
        elsif char == '#'
          curr = 1
          on_hash = true
        elsif char == '?'
          return numbers
        else
          raise 'wtf else'
        end
      end
    end

    numbers << curr if curr > 0
    numbers
  end
end

def check_line(line, numbers)
  $number_checked += 1
  # Sub problem is computed by knocking off completed sections
  known_numbers = PicrossLine.new(line).known_numbers
  return 0 if known_numbers.count > numbers.count

  remaining_numbers = numbers.dup
  matched_numbers = []
  known_numbers.each do |known_number|
    if known_number == remaining_numbers.first
      matched_numbers << remaining_numbers.shift
    else
      return 0
    end
  end

  sum = matched_numbers.sum
  if sum > 0
    remaining_line = line.dup
    found_hashes = 0
    split = remaining_line.split('')
    until found_hashes == sum
      found_hashes += 1 if split.shift == '#'
    end
    remaining_line = split.join
  else
    remaining_line = line.dup
  end

  while remaining_line[0] == '.'
    remaining_line = remaining_line[1..-1]
  end

  return 1 if remaining_numbers.empty? && !remaining_line.include?('#')

  return 0 unless remaining_line.include?('?')

  return check_line(remaining_line.sub('?', '.'), remaining_numbers) +
    check_line(remaining_line.sub('?', '#'), remaining_numbers)
end

count = 0

def try_1
  $lines.each_with_index do |line, y|
    springs, picross = line.split(' ')
    picross = picross.split(',').map(&:to_i)

    springs = "#{springs}?#{springs}?#{springs}?#{springs}?#{springs}"
    picross = picross * 5

    $number_checked = 0
    value = check_line(springs, picross)
    puts "#{y}: #{value}"
    puts "number checked: #{$number_checked}"
    count += value
  end

  puts count
end

#try_1

class PicrossCheck
  def self.check(line, index, number)
    return false if line[0...index].include?('#')
    return false if line[index...index+number].include?('.')
    return false if line[index+number] == '#'

    return true
  end
end


class Picross2
  def initialize
    @solutions = {}
  end

  def check_line2(line, numbers)
    # Iterate through with the first number, and for each location where the
    # number *could* fit, call a sub-problem removing that 
    # part of the line and the first number
    if @solutions.key?([line, numbers])
      return @solutions.fetch([line, numbers])
    end

    if numbers.empty?
      # Confirm line is ok
      return 0 if line.include?('#')
      return 1
    else
      first_num = numbers[0]
      return 0 if first_num > line.length
  
      this_count = 0
  
      (line.length - first_num + 1).times do |i|
        result = PicrossCheck.check(line, i, first_num)
  
        if result
          # this slot works. We will sub-problem by knocking off the first
          # part of the line and first number
          this_count += check_line2(line[i+first_num+1..-1], numbers[1..-1])
        else
          # doesn't work, so, forget it
        end
      end
  
      @solutions[[line, numbers]] = this_count

      return this_count
    end
  
  end
end



def try_2
  count = 0
  $lines.each_with_index do |line, y|
    springs, picross = line.split(' ')
    picross = picross.split(',').map(&:to_i)

    springs = ".#{springs}?#{springs}?#{springs}?#{springs}?#{springs}."
    picross = picross * 5

    value = Picross2.new.check_line2(springs, picross)
    puts "#{y}: #{value}"
    count += value
  end

  puts count
end

try_2