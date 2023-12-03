# frozen_string_literal: true

require_relative "cursor"
require_relative "bfs"

module Aoc
  # A grid is a two dimensional array of values.  The grid is indexed by
  class Grid
    def animate_path(path)
      path.each do |cursor|
        temp = clone
        temp[cursor.x, cursor.y] = "*"
        print "\033[2J\033[0;0H"
        puts temp
        sleep 0.3
      end
    end

    def to_s
      @grid.reduce("") do |acc, row|
        "#{acc}#{row.reduce("") { |acc2, col| acc2 + col.to_s }}\n"
      end
    end
  end
end
