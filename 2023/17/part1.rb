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

x_max = lines[0].length - 1
y_max = lines.count - 1

class State
  attr_reader :pos, :heat_loss, :momentum, :last_dir, :path

  def initialize(pos, heat_loss, momentum, last_dir, path)
    @pos = pos
    @heat_loss = heat_loss
    @momentum = momentum
    @last_dir = last_dir
    @path = path
  end

  def to_key
    "#{pos}:#{momentum}:#{last_dir}"
  end
end

base_state = State.new(Point.new(0,0), 0, 0, nil, [])

states_found = {}
queue = [base_state]

max_depth_hit = 0

until queue.empty?
  state = queue.pop
  next if states_found.key?(state.to_key) && states_found[state.to_key].fetch(:heat_loss) <= state.heat_loss

  if state.path.count > max_depth_hit
    max_depth_hit = state.path.count
    puts "NEW MAX DEPTH: #{max_depth_hit}"
  end

  # Add any new states to the queue
  point = state.pos
  # left
  new_point = point.mx
  if new_point.x >= 0 && state.last_dir != :right
    new_momentum = state.last_dir == :left ? state.momentum + 1 : 1
    if new_momentum != 4
      queue.unshift(State.new(new_point, state.heat_loss + map.fetch(new_point).to_i, new_momentum, :left, state.path + [:left]))
    end
  end
  # right
  new_point = point.px
  if new_point.x <= x_max && state.last_dir != :left
    new_momentum = state.last_dir == :right ? state.momentum + 1 : 1
    if new_momentum != 4
      queue.unshift(State.new(new_point, state.heat_loss + map.fetch(new_point).to_i, new_momentum, :right, state.path + [:right]))
    end
  end
  # up
  new_point = point.my
  if new_point.y >= 0 && state.last_dir != :down
    new_momentum = state.last_dir == :up ? state.momentum + 1 : 1
    if new_momentum != 4
      queue.unshift(State.new(new_point, state.heat_loss + map.fetch(new_point).to_i, new_momentum, :up, state.path + [:up]))
    end
  end
  # down
  new_point = point.py
  if new_point.y <= y_max && state.last_dir != :up
    new_momentum = state.last_dir == :down ? state.momentum + 1 : 1
    if new_momentum != 4
      queue.unshift(State.new(new_point, state.heat_loss + map.fetch(new_point).to_i, new_momentum, :down, state.path + [:down]))
    end
  end

  if states_found.key?(state.to_key)
    if state.heat_loss < states_found.fetch(state.to_key).fetch(:heat_loss)
      states_found[state.to_key] = {heat_loss: state.heat_loss, path: state.path}
    end
  else
    states_found[state.to_key] = {heat_loss: state.heat_loss, path: state.path}
  end
end

result = states_found.select do |key, array|
  key.start_with?("<#{x_max},#{y_max}>")
end.values.flatten.min do |a, b|
  a.fetch(:heat_loss) <=> b.fetch(:heat_loss)
end

puts result