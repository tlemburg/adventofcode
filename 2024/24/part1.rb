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
  else
    if line.empty?
      break_found = true
    else
      wire, input = line.split(': ')
      wires[wire] = (input == '1')
    end
  end
end

changes = true
while changes
  changes = false
  # Iterate through gates
  gates.each do |gate|
    if wires.fetch(gate.fetch(:out)).nil?
      if !wires.fetch(gate.fetch(:in1)).nil? && !wires.fetch(gate.fetch(:in2)).nil?
        changes = true
        puts gate
        wires[gate.fetch(:out)] = case gate.fetch(:op)
        when 'AND'
          wires.fetch(gate.fetch(:in1)) && wires.fetch(gate.fetch(:in2))
        when 'OR'
          wires.fetch(gate.fetch(:in1)) || wires.fetch(gate.fetch(:in2))
        when 'XOR'
          wires.fetch(gate.fetch(:in1)) ^ wires.fetch(gate.fetch(:in2))
        else
          raise 'holy shitballs'
        end
      end
    end
  end
end

binary = wires.select do |key, value|
  key.start_with?('z')
end.to_a.sort_by(&:first)

binary = binary.reverse.map(&:last).map do |bool|
  bool ? '1' : '0'
end.join.to_i(2)

p binary