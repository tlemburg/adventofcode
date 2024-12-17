#!/usr/bin/env ruby

require_relative '../../point'
require 'set'

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

# Assuming the map is a rectangle
x_max = lines[0].length - 1
y_max = lines.count - 1
x_range = (0..x_max)
y_range = (0..y_max)

reg_a = lines[0].split(': ').last.to_i
reg_b = lines[1].split(': ').last.to_i
reg_c = lines[2].split(': ').last.to_i

program = lines[4].split(': ').last.split(',').map(&:to_i)

pointer = 0

halt = false

output = []

class Registers
  attr_accessor :a, :b, :c

  def initialize(a:, b:, c:)
    @a = a
    @b = b
    @c = c
  end

  def combo(number)
    case number
    when (0..3)
      number
    when 4
      a
    when 5
      b
    when 6
      c
    end
  end
end

reg = Registers.new(a: reg_a, b: reg_b, c: reg_c)

while !halt
  if pointer >= program.count || pointer < 0
    halt = true
    next
  end

  jumping = false
  opcode = program[pointer]
  operand = program[pointer+1]
  case opcode
  when 0
    num = reg.a
    denom = 2**reg.combo(operand)
    reg.a = num / denom
  when 1
    reg.b = reg.b ^ operand
  when 2
    reg.b = reg.combo(operand) % 8
  when 3
    if reg.a != 0
      jumping = true
      pointer = operand
    end
  when 4
    reg.b = reg.b ^ reg.c
  when 5
    output << reg.combo(operand) % 8
  when 6
    num = reg.a
    denom = 2**reg.combo(operand)
    reg.b = num / denom
  when 7
    num = reg.a
    denom = 2**reg.combo(operand)
    reg.c = num / denom
  end

  if !jumping
    pointer += 2
  end
end

puts output.join(',')
