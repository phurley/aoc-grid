# frozen_string_literal: true

require_relative "./cursor"
require_relative "./bfs"

module Aoc
  # A grid is a two dimensional array of values.  The grid is indexed by
  class Grid
    attr_reader :width, :height

    def initialize(width, height, default: nil, &block)
      @width = width
      @height = height
      @grid = if block_given?
                Array.new(height) { |y| Array.new(width) { |x| block.call(x, y) } }
              else
                Array.new(height) { Array.new(width, default) }
              end
    end

    def self.from_file(fname)
      lines = File.readlines(fname).map(&:chomp)
      width = lines.max { |line| line.size || 0 }.size
      height = lines.size

      Grid.new(width, height) do |x, y|
        lines[y][x]
      end
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

    def add_path(path)
      num = 0
      clone.tap do |result|
        path.each do |cursor|
          result[cursor.x, cursor.y] = (num % 10).to_s
          num += 1
        end
      end
    end

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
