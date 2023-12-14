# frozen_string_literal: true

module Aoc
  # A grid is a two dimensional array of values.  The grid is indexed by
  class Cursor
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

    alias north up
    alias south down
    alias east right
    alias west left
    alias northeast up_right
    alias northwest up_left
    alias southeast down_right
    alias southwest down_left

    def delta(other)
      [other.x - x, other.y - y]
    end

    def direction_while(direction, cond)
      result = self

      peek = result.send(direction)
      while peek === cond
        result = peek
        peek = result.send(direction)
      end

      result
    rescue Aoc::Error
      result
    end

    def ===(other)
      case other
      when Cursor
        self == other

      when Array
        [x, y] == other # rubocop:disable Style/YodaCondition

      when String
        get == other

      else
        false
      end
    end
  end
end
