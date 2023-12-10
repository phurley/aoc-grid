# frozen_string_literal: true

require_relative "cursor"
require_relative "bfs"

# Wrapper for all Advent of Code tools
module Aoc
  include Enumerable
  # A grid is a two dimensional array of values.  The grid is indexed by
  class Grid
    attr_reader :width, :height

    def initialize(width, height, default: nil, &block)
      @width = width
      @height = height
      @grid = if block
                Array.new(height) { |y| Array.new(width) { |x| yield(x, y) } }
              else
                Array.new(height) { Array.new(width, default) }
              end
    end

    def self.from_file(fname)
      from_string(File.read(fname))
    end

    def self.from_string(string)
      lines = string.each_line.map(&:chomp)
      width = lines.map { |l| l.size || 0 }.max
      height = lines.size

      Grid.new(width, height) do |x, y|
        lines[y][x]
      end
    end

    def inflate
      Grid.new((width * 2) + 1, (height * 2) + 1) do |x, y|
        if x.odd? && y.odd?
          at(x / 2, y / 2)
        else
          block_given? ? yield(x, y) : " "
        end
      end
    end

    def deflate
      Grid.new(width / 2, height / 2) do |x, y|
        at((x * 2) + 1, (y * 2) + 1)
      end
    end

    def each
      @grid.each_with_index do |row, y|
        row.each_with_index do |_value, x|
          yield Cursor.new(self, x, y)
        end
      end
    end

    def at(x, y)
      raise Aoc::Error, "Invalid coordinate #{x},#{y}" unless valid?(x, y)

      @grid[y][x]
    end

    def [](x, y)
      raise Aoc::Error, "Invalid coordinate #{x},#{y}" unless valid?(x, y)

      @grid[y][x]
    end

    def []=(x, y, value)
      raise Aoc::Error, "Invalid coordinate #{x},#{y}" unless valid?(x, y)

      @grid[y][x] = value
    end

    def valid?(x, y)
      x >= 0 && x < @width && y >= 0 && y < @height
    end

    def cursor(x = 0, y = 0)
      raise Aoc::Error, "Invalid coordinate #{x},#{y}" unless valid?(x, y)

      Cursor.new(self, x, y)
    end
  end
end
