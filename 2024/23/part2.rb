#!/usr/bin/env ruby

require_relative '../../point'
require 'set'

test = ARGV[0] == '--test'

in_file = test ? 'test_in.txt' : 'real_in.txt'

lines = []
 
File.readlines(in_file, chomp: true).each_with_index do |line, y|
  lines << line
end

connections = {}

lines.each do |line|
  c1, c2 = line.split('-')
  
  connections[c1] ||= Set[]
  connections[c1] << c2

  connections[c2] ||= Set[]
  connections[c2] << c1
end
