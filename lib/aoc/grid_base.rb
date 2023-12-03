# frozen_string_literal: true

require_relative "cursor"
require_relative "bfs"

module Aoc
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

    def each_row
      @grid.each_with_index do |row, y|
        return to_enum(:each_row) unless block_given?

        yield row, y
      end
    end

    def each_column(&)
      return to_enum(:each_column) unless block_given?

      width.times do |x|
        height.times do |y|
          yield cursor(x, y)
        end
      end
    end

    def find_horizontal_regions(regex)
      each_row.map do |row, y|
        row.map.with_index { |_ch, x| cursor(x, y) }
           .chunk { |cursor| !cursor.to_s.match(regex).nil? }
           .filter { |match, _cursors| match }
           .map { |_match, cursors| Region.new(cursors) }
      end.flatten
    end

    def find_cursors(regex)
      cursors = []
      @grid.each_with_index do |row, y|
        row.each_with_index do |ch, x|
          cursors << cursor(x, y) if ch.match(regex)
        end
      end
      cursors
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
