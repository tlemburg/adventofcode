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
$x_range = (0..x_max)
$y_range = (0..y_max)

guard_point = map.select do |point, char|
  char == '^'
end.to_a.first.first

total = 0

class State
  attr_accessor :map, :guard_point, :guard_dir, :traversed, :object_placed, :moves

  def initialize(map:, guard_point:, guard_dir:, traversed:, moves:, object_placed: false)
    @map = map.dup
    @guard_point = guard_point.dup
    @guard_dir = guard_dir.dup
    @object_placed = object_placed
    @traversed = traversed.dup
    @moves = moves
  end

  def copy
    self.class.new(
      map: self.map,
      moves: self.moves,
      guard_point: self.guard_point,
      guard_dir: self.guard_dir,
      object_placed: self.object_placed,
      traversed: self.traversed
    )
  end

  def to_s
    "<State guard_point=#{guard_point} guard_dir=#{guard_dir} moves=#{moves} object_placed=#{object_placed}> traversed=#{traversed}"
  end

  def inspect
    to_s
  end

  def add_obstacle
    unless self.object_placed
      case self.guard_dir
      when :up
        self.map[guard_point.my] = '#' if $y_range.include?(guard_point.my.y) && self.map[guard_point.my] != '#'
      when :down
        self.map[guard_point.py] = '#' if $y_range.include?(guard_point.py.y) && self.map[guard_point.py] != '#'
      when :left
        self.map[guard_point.mx] = '#' if $x_range.include?(guard_point.mx.x) && self.map[guard_point.mx] != '#'
      when :right
        self.map[guard_point.px] = '#' if $x_range.include?(guard_point.px.x) && self.map[guard_point.px] != '#'
      else
        raise 'invalid guard dir'
      end
      self.object_placed = true
    end
  end

  def move_guard
    self.traversed << [guard_point.x, guard_point.y, guard_dir]

    case guard_dir
    when :up
      if map[guard_point.my] == '#'
        self.guard_dir = :right
      else
        self.guard_point = self.guard_point.my
      end
    when :down
      if map[guard_point.py] == '#'
        self.guard_dir = :left
      else
        self.guard_point = self.guard_point.py
      end
  
    when :left
      if map[guard_point.mx] == '#'
        self.guard_dir = :up
      else
        self.guard_point = self.guard_point.mx
      end
    when :right
      if map[guard_point.px] == '#'
        self.guard_dir = :down
      else
        self.guard_point = self.guard_point.px
      end
    end

    self.moves += 1
  end

  def looped?
    self.traversed.include?([self.guard_point.x, self.guard_point.y, self.guard_dir])
  end

  def guard_on_map?
    $x_range.include?(guard_point.x) && $y_range.include?(guard_point.y)
  end
end

states = [
  State.new(map: map, guard_point: guard_point, guard_dir: :up, traversed: Set[], object_placed: false, moves: 0)
]

until states.empty?
  state = states.shift

  next if state.moves > 3

  puts "Processing state: #{state}"

  if !state.object_placed
    # Make a copy with the object, and add to queue
    new_state = state.copy
    new_state.add_obstacle
    states << new_state
  end

  if state.looped?
    total += 1
    # Do not reprocess
  end

  state.move_guard

  if state.guard_on_map?
    states << state
  end

  #binding.irb

end

puts total