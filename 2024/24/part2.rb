#!/usr/bin/env ruby

require_relative '../../point'
require 'set'

test = ARGV[0] == '--test'

in_file = test ? 'test_in.txt' : 'real_in.txt'

lines = []
 
File.readlines(in_file, chomp: true).each_with_index do |line|
  lines << line
end

wires = {}
gates = []

gates_to_strings = {}

break_found = false
lines.each do |line|
  if break_found
    words = line.split(' ')
    gates << {
      op: words[1],
      in1: words[0],
      in2: words[2],
      out: words[4]
    }
    wires[words[0]] = nil unless wires.key?(words[0])
    wires[words[2]] = nil unless wires.key?(words[2])
    wires[words[4]] = nil unless wires.key?(words[4])

    gates_to_strings[words[4]] = words[0..2].join(' ')
  else
    if line.empty?
      break_found = true
    else
      wire, input = line.split(': ')
      wires[wire] = (input == '1')
    end
  end
end

# Break down what every z output comes from
(0..13).each do |i|
  next if i > 46
  locked_wires = Set[]

  z_key = "z#{i.to_s.rjust(2, '0')}"

  string = gates_to_strings.fetch(z_key)

  found = true
  while found
    found = false
    string.gsub('(', '').gsub(')', '').split(' ').each do |word|
      next if word == word.upcase

      if !word.match?(/\A[xyz]\d{2}\z/)
        locked_wires << word
        found = true
        string = string.gsub(word, "(#{gates_to_strings.fetch(word)})")
      end

    end
  end
  
  # From the String, create an abstract syntax tree.
  # We know the answers to what z00, z01, and z02.
  # Other Z's beyond that can be inferred: (inferring zi+1 from zi)
  # 1. Convert the highest level XOR to AND (this is zi-esc)
  # 2. Add (x_i AND y_i) OR to the start (this is also zi-esc)
  # 3. Add (x_i+1 XOR y_i+1) XOR to the start. This is the highest level
  # XOR.

  p z_key
  p string
  p locked_wires

end