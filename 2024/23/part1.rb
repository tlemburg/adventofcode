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

parties = Set[]

lines.each do |line|
  c1, c2 = line.split('-')
  
  connections[c1] ||= Set[]
  connections[c1] << c2

  connections[c2] ||= Set[]
  connections[c2] << c1
end

connections.keys.each do |c1|
  next unless c1[0] == 't'

  connections[c1].each do |c2|
    (connections[c1] & connections[c2]).each do |c3|
      parties << [c1, c2, c3].sort
    end
  end
end

puts parties.count