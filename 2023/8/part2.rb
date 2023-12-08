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

dirs = lines.shift
lines.shift
map = {}

lines.each do |line|
  node = line.split(' = ').first
  left = line.split('(').last[0..2]
  right = line.split(', ').last[0..2]
  map[node] = {'L' => left, 'R' => right}
end

currs = map.keys.select do |key|
  key.end_with?('A')
end

count = 0
index = 0
currs_log = []

classes = {

}

(0...currs.count).each do |j|
  index = 0
  curr = currs[j]
  currs_log[j] = [[0, curr]]

  multiplier = nil
  offsets = nil

  loop do
    dir = dirs[index]
    curr = map[curr][dir]
    index += 1
    index = index % dirs.length

    if found = currs_log[j].index([index, curr])

      multiplier = currs_log[j].count - found
      offsets = currs_log[j].each_with_index.map do |item, index|
        [item, index]
      end.select do |item, index|
        item.last.end_with?('Z')
      end.map do |item, index|
        index % multiplier
      end
      break
    end
    currs_log[j] << [index, curr]
  end

  puts '----'
  offsets.each do |offset|
    puts "#{multiplier}n + #{offset}"
  end
  puts '****'

  classes[j] = {
    multiplier: multiplier,
    offsets: offsets
  }
end

(0...1000000).each do |i|
  classes[0][:offsets].each do |offset|
    number = classes[0][:multiplier] * i + offset
    next if number == 0

    ## see if number matches other classes
    works = (1...classes.count).all? do |j|
      classes[j][:offsets].any? do |offset|
        number % classes[j][:multiplier] == offset
      end
    end

    if works
      puts 'solution:'
      puts number
      exit
    end
  end
end

# I found lowest common multiple of the multipliers using Wolfram Alpha
# but you could easily chain Integer.lcm