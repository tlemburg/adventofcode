#!/usr/bin/env ruby

require_relative '../../point'
require 'set'

test = ARGV[0] == '--test'

in_file = test ? 'test_in.txt' : 'real_in.txt'

lines = []
 
File.readlines(in_file, chomp: true).each_with_index do |line, y|
  lines << line
end

total = 0
MODULUS = 16777216

lines.each do |line|
  num = line.to_i
  2000.times do
    s1 = num * 64
    num = (num ^ s1) % MODULUS

    s2 = num / 32
    num = (num ^ s2) % MODULUS

    s3 = num * 2048
    num = (num ^ s3) % MODULUS
  end
  total += num
end

p total