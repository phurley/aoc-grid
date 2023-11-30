# frozen_string_literal: true

require "aocgrid"

puts Dir.pwd
fname = ARGV.first
puts fname
g = Aoc::Grid.from_file(fname)
start = g.cursor(1, 1)
stop = g.cursor(8, 8)

path = Aoc::BFS.solve(start, stop, Aoc::Cursor::DIRECTIONS) { |pos| pos.to_s == " " }
puts g

puts path.inspect

g.animate_path(path)
