# frozen_string_literal: true

require_relative "cursor"
require_relative "bfs"

# Wrapper for all Advent of Code tools
module Aoc
  include Enumerable
  # A grid is a two dimensional array of values.  The grid is indexed by
  class SparseGrid
    attr_reader :width, :height, :default

    def initialize(width, height, default: nil) # rubocop:disable Metrics/MethodLength
      @width = width
      @height = height
      @default = default
      @grid = Hash.new(default)
      return unless block_given?

      height.times do |y|
        width.times do |x|
          value = yield(x, y)
          @grid[[x, y]] = value if value != default
        end
      end
    end

    def self.from_file(fname)
      from_string(File.read(fname))
    end

    def self.from_string(string, default: " ")
      lines = string.each_line.map(&:chomp)
      width = lines.map { |l| l.size || 0 }.max
      height = lines.size

      Grid.new(width, height, default:) do |x, y|
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
      width.times do |x|
        height.times do |y|
          yield Cursor.new(self, x, y)
        end
      end
    end

    def at(x, y)
      raise Aoc::Error, "Invalid coordinate #{x},#{y}" unless valid?(x, y)

      @grid[[x, y]]
    end

    def [](x, y)
      raise Aoc::Error, "Invalid coordinate #{x},#{y}" unless valid?(x, y)

      at(x, y)
    end

    def []=(x, y, value)
      raise Aoc::Error, "Invalid coordinate #{x},#{y}" unless valid?(x, y)

      if default === value
        @grid.delete([x, y])
      else
        @grid[[x, y]] = value
      end
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
