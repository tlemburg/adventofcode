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

full_lines = []
curr = []
lines.each do |line|
  if line == ''
    full_lines << curr
    curr = []
  else
    curr << line
  end
end
full_lines << curr

seed_ranges = []
data = {}

full_lines.each_with_index do |line_set, index|
  if index == 0
    seed_nums = line_set.first.split(':').last.strip.split(' ').map(&:to_i)
    seed_nums.each_with_index do |num, j|
      next if j % 2 == 1
      seed_ranges << (num..num+seed_nums[j+1]-1)
    end
  else
    line_set.each_with_index do |line, o|
      next if o == 0
      data[index.to_s] ||= []
      data[index.to_s] << line.split(' ').map(&:to_i)
    end
  end
end

(1..7).each do |i|
  puts "ITERATION #{i} *&*&*&*&*&*&*&*&*&*&*&*&"
  puts 'SEED RANGES FOR THIS ITERATION'
  puts seed_ranges.inspect

  map = data[i.to_s]
  new_seed_ranges = []

  seed_ranges.each do |seed_range|
    puts '*************'
    considered_ranges = [seed_range]
    puts 'CONSIDERED RANGES'
    puts considered_ranges.inspect

    until considered_ranges.empty?
      puts '----------------------'
      considered_range = considered_ranges.shift
      puts 'CONSIDERED RANGE'
      puts considered_range.inspect
      matched = false

      map.each do |dest, source, length|
        break if matched
        translation = dest - source
        source_range = (source..source+length-1)
        puts 'SOURCE RANGE'
        puts source_range.inspect

        if considered_range.min >= source_range.min && considered_range.max <= source_range.max
          # Entire range converts, done with this considered range
          new_seed_ranges << (considered_range.min+translation..considered_range.max+translation)
          matched = true
          puts 'entire range converted'
        else
          if considered_range.min >= source_range.min && considered_range.max > source_range.max && source_range.max >= considered_range.min
            # The considered range intersects with the source range on the right.
            # Translate the part of considered range which intersects.
            # Take the remainder and add it back to considered ranges.
            new_seed_ranges << (considered_range.min+translation..source_range.max+translation)
            considered_ranges << (source_range.max+1..considered_range.max)
            matched = true
            puts 'intersect right'
          elsif considered_range.min < source_range.min && considered_range.max <= source_range.max && source_range.min <= considered_range.max
            new_seed_ranges << (source_range.min+translation..considered_range.max+translation)
            considered_ranges << (considered_range.min..source_range.min-1)
            matched = true
            puts 'intersect left'
          elsif considered_range.min < source_range.min && considered_range.max > source_range.max
            # the considered range is bigger than the source range to map, so we need to split off both ends.
            new_seed_ranges << (source_range.min+translation..source_range.max+translation)
            considered_ranges << (considered_range.min..source_range.min-1)
            considered_ranges << (source_range.max+1..considered_range.max)
            matched = true
            puts 'considered range bigger - intersect both'
          else
            # not found
          end
        end
      end

      if !matched
        # Then this range should go through without translation
        new_seed_ranges << considered_range
        puts 'no match at all, passing through'
      end

      puts 'NEW SEED RANGES'
      puts new_seed_ranges.inspect
      puts 'CONSIDERED RANGES'
      puts considered_ranges.inspect

    end
  end
  
  seed_ranges = new_seed_ranges
end

puts seed_ranges.map(&:min).min