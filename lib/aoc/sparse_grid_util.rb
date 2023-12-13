# frozen_string_literal: true

require_relative "cursor"
require_relative "bfs"

# Module for all Advent of Code tools
module Aoc
  # A grid is a two dimensional array of values.  The grid is indexed by
  class SparseGrid
    include Enumerable
    def each_row
      return to_enum(:each_row) unless block_given?

      height.times do |y|
        yield Array.new(width) { |x| cursor(x, y) }
      end
    end

    def each_column
      return to_enum(:each_column) unless block_given?

      width.times do |x|
        yield Array.new(height) { |y| cursor(x, y) }
      end
    end

    def add_row(pos, default: " ")
      @height += 1
      @grid = @grid.to_h do |(x, y), v|
        [x, y > pos ? y + 1 : y, v]
      end
      return unless default != @default

      width.times do |x|
        @grid.store([x, pos], default)
      end
    end

    def add_column(pos, default: " ")
      @width += 1
      @grid = @grid.to_h do |(x, y), v|
        [x > pos ? x + 1 : x, y, v]
      end
      return unless default != @default

      height.times do |y|
        @grid.store([pos, y], default)
      end
    end

    def find_horizontal_regions(regex)
      each_row.map do |row|
        row.chunk { |cursor| !cursor.get.match(regex).nil? }
           .filter { |match, _cursors| match }
           .map { |_match, cursors| Region.new(cursors) }
      end.flatten
    end

    def find_vertical_regions(regex)
      each_column.map do |row|
        row.chunk { |cursor| !cursor.to_s.match(regex).nil? }
           .filter { |match, _cursors| match }
           .map { |_match, cursors| Region.new(cursors) }
      end.flatten
    end

    def find_cursors(cond)
      @grid.filter_map { |(x, y), val| cursor(x, y) if cond === val }
    end

    def follow(start, stop)
      result = [start]
      pos = yield(start)
      until stop === pos
        result << pos
        pos = yield(pos)
      end
      result
    end

    def add_path(path)
      num = 0
      clone.tap do |result|
        path.each do |cursor|
          result[cursor.x, cursor.y] = (num % 10).to_s
          num += 1
        end
      end
    end
  end
end
