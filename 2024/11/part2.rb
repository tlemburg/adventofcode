#!/usr/bin/env ruby

require_relative '../../point'
require 'set'

test = ARGV[0] == '--test'

in_file = test ? 'test_in.txt' : 'real_in.txt'

lines = []
 
File.readlines(in_file, chomp: true).each_with_index do |line, y|
  lines << line
end

stones = lines[0].split(' ').map(&:to_i)

def blink(stone)

  val = if stone == 0
    [1]
  elsif stone.to_s.length.even?
    [
      stone.to_s[0..(stone.to_s.length / 2 - 1)].to_i, 
      stone.to_s[(stone.to_s.length / 2)..stone.to_s.length-1].to_i
    ]
  else
    [stone * 2024]
  end


  return val
end

def array_blink(stones)
  new_stones = []
  stones.each do |stone|
    new_stones += blink(stone)
  end
  new_stones
end

# PRE GENERATE MEMO OF SINGLE DIGITS TO 10 steps
MEMO = {}
def calc_memo(stone)
  count = 0
  stones = [stone]

  while count < 16
    stones = array_blink(stones)
    count += 1
    MEMO[stone] ||= {}
    MEMO[stone][count] = {list: stones, count: stones.count}
  end
end
(0..9).each do |digit|
  calc_memo(digit)
end

ROUNDS = 75

def stone_count_after_rounds(stones, num_rounds)
  if num_rounds == 0
    return stones.count
  end

  if stones.count > 1
    return stones.map do |stone|
      stone_count_after_rounds([stone], num_rounds)
    end.sum
  end

  # we have one stone. 
  stone = stones.first
  if !MEMO.key?(stone)
    calc_memo(stone)
  end

  if num_rounds <= 15
    return MEMO[stone][num_rounds].fetch(:count)
  end

  if MEMO[stone][num_rounds]&.[](:count)
    return MEMO[stone][num_rounds][:count]
  end

  val = stone_count_after_rounds(MEMO[stone].fetch(15).fetch(:list), num_rounds - 15)
  MEMO[stone][num_rounds] ||= {}
  MEMO[stone][num_rounds][:count] = val

  val

end

puts stone_count_after_rounds(stones, ROUNDS)