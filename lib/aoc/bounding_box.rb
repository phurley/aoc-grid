# frozen_string_literal: true

module Aoc
  # A collection of cursors
  class BoundingBox
    include Comparable
    attr_reader :top, :bottom, :left, :right

    def initialize(x1, y1, x2, y2)
      @top = [y1, y2].min
      @bottom = [y1, y2].max
      @left = [x1, x2].min
      @right = [x1, x2].max
    end

    def <=>(other)
      [top, left, bottom, right] <=> [other.top, other.left, other.bottom, other.right]
    end

    def eql?(other)
      self == other
    end

    def hash
      [top, left, bottom, right].hash
    end

    def neighbors(wrap: false)
      # TODO: implement
    end

    def include?(cursor)
      top <= cursor.y && cursor.y <= bottom && left <= cursor.x && cursor.x <= right
    end

    def width
      bottom - top + 1
    end

    def height
      right - left + 1
    end

    def size
      width * height
    end

    def to_region(grid)
      Region.new((top..bottom).flat_map { |y| (left..right).map { |x| grid.cursor(x, y) } })
    end

    def to_s
      [top, left, bottom, right].inspect
    end

    def merge(other)
      BoundingBox.new([top, other.top].min, [bottom, other.bottom].max,
                      [left, other.left].min, [right, other.right].max)
    end
  end
end
