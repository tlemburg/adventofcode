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
  first = nil
  last = nil

  hash = {
    one: 1,
    two: 2,
    three: 3,
    four: 4,
    five: 5,
    six: 6,
    seven: 7,
    eight: 8,
    nine: 9,
    zero: 0,
    "1" => 1,
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
    "0" => 0
  }

  finds = []
  (0...line.length).each do |start_index|
    hash.keys.each do |key|
      if line[start_index..-1].start_with?(key.to_s)
        finds << hash.fetch(key)
      end
    end
  end

  puts finds.inspect

  count += finds.first * 10 + finds.last
end

puts count