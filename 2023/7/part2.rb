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

class Hand
  include Comparable
  attr_accessor :cards

  TYPES = [
    :five_of_a_kind,
    :four_of_a_kind,
    :full_house,
    :three_of_a_kind,
    :two_pair,
    :one_pair,
    :high_card
  ].reverse 

  CARDS = %w(A K Q T 9 8 7 6 5 4 3 2 J).reverse

  def to_s
    @cards.join
  end

  def initialize(string)
    @cards = string.split('')
    raise 'oh whaat' if @cards.count != 5
  end

  def type(cards = @cards)
    if cards.include?('J')
      subhands = CARDS[1..-1].map do |card|
        subcards = cards.dup
        subcards[subcards.index('J')] = card
        type(subcards)
      end

      subhands.sort_by do |subhand|
        TYPES.index(subhand)
      end.last

    else
      hand_type(cards)
    end

  end

  def hand_type(cards)
    tally = cards.tally.to_a.sort_by(&:last).reverse
    return :five_of_a_kind if tally.count == 1
    return :four_of_a_kind if tally.first.last == 4
    return :full_house if tally.first.last == 3 && tally.last.last == 2
    return :three_of_a_kind if tally.first.last == 3
    return :two_pair if tally.first.last == 2 and tally[1].last == 2
    return :one_pair if tally.first.last == 2
    return :high_card
  end

  def <=>(other)
    if TYPES.index(type) != TYPES.index(other.type)
      return TYPES.index(type) <=> TYPES.index(other.type)
    end

    @cards.each_with_index do |card, i|
      other_card = other.cards[i]
      if (CARDS.index(card) <=> CARDS.index(other_card)) != 0
        return CARDS.index(card) <=> CARDS.index(other_card)
      end
    end

    return 0
  end
end

hands = []

lines.each do |line|
  hand, bet = line.split(' ')
  hand = Hand.new(hand)
  bet = bet.to_i
  hands << [hand, bet]
end

hands = hands.sort_by(&:first).reverse

puts hands

score = 0

hands.each_with_index do |hand_arr, i|
  bet = hand_arr[1]
  score += bet * (hands.count - i)
end

puts score