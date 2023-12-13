# frozen_string_literal: true

require_relative "cursor"
require_relative "bfs"

# Module for all Advent of Code tools
module Aoc
  # A grid is a two dimensional array of values.  The grid is indexed by
  class Grid
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
      @grid.insert(pos, Array.new(width, default))
      @height = @grid.size
    end

    def add_column(pos, default: " ")
      @grid.each do |row|
        row.insert(pos, default)
      end
      @width = @grid.first.size
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
      cursors = []
      @grid.each_with_index do |row, y|
        row.each_with_index do |val, x|
          cursors << cursor(x, y) if cond === val
        end
      end
      cursors
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
