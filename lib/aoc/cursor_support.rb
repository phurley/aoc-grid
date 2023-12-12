# frozen_string_literal: true

require "set"

module Aoc
  # A grid is a two dimensional array of values.  The grid is indexed by
  class Cursor
    def to_s
      @grid[x, y].to_s
    end

    def up
      @grid.cursor(x, y - 1)
    end

    def down
      @grid.cursor(x, y + 1)
    end

    def left
      @grid.cursor(x - 1, y)
    end

    def right
      @grid.cursor(x + 1, y)
    end

    def down_left
      @grid.cursor(x - 1, y + 1)
    end

    def down_right
      @grid.cursor(x + 1, y + 1)
    end

    def up_left
      @grid.cursor(x - 1, y - 1)
    end

    def up_right
      @grid.cursor(x + 1, y - 1)
    end

    def delta(other)
      [other.x - x, other.y - y]
    end
  end
end
