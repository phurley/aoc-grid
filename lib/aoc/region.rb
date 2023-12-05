# frozen_string_literal: true

module Aoc
  # A collection of cursors
  class Region
    include Comparable

    def initialize(cursors)
      @region = cursors.sort
    end

    def add!(cursor)
      @region << cursor
      @region.sort!
    end

    def <=>(other)
      @region <=> other.to_a
    end

    def eql?(other)
      @region.eql?(other.to_a)
    end

    def hash
      @region.hash
    end

    def neighbors(wrap: false)
      (@region.flat_map { |cursor| cursor.neighbors(wrap:) }.uniq - @region).sort
    end

    def include?(cursor)
      @region.include?(cursor)
    end

    def size
      @region.size
    end

    def to_a
      @region
    end

    def to_s
      @region.map(&:to_s).join
    end

    def merge(other)
      Region.new(@region | other.to_a)
    end

    def clone
      Region.new(@region.map(&:clone))
    end

    def bounding_box
      min_x = min_y = 999_999_999_999
      max_x = max_y = 0

      @region.each do |cursor|
        min_x = [min_x, cursor.x].min
        min_y = [min_y, cursor.y].min
        max_x = [max_x, cursor.x].max
        max_y = [max_y, cursor.y].max
      end

      BoundingBox.new(min_x, min_y, max_x, max_y)
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/PerceivedComplexity
    # rubocop:disable Style/CaseEquality
    def fill!(from: " ", to: "#")
      # find bounding box
      bb = bounding_box
      grid = @region.first.grid

      # find interior (by BFS exterior around bounding box)
      exterior = []
      (bb.top..bb.bottom).each do |y|
        [bb.left, bb.right].each do |x|
          next if exterior.include?([x, y])

          BFS.visit(grid.cursor(x, y)) { |cursor| from === cursor.to_s && bb.include?(cursor) }.each do |pos|
            next if exterior.include?(pos)

            exterior << pos
          end
        end
      end

      interior = @region - exterior
      # fill interior
      interior.each do |cursor|
        BFS.visit(cursor) { |c| from === c.to_s }.each do |pos|
          grid[pos.x, pos.y] = to
        end
      end
    end
    # rubocop:enable Style/CaseEquality
    # rubocop:enable Metrics/PerceivedComplexity
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize
  end
end
