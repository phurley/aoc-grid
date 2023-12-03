# frozen_string_literal: true

module Aoc
  # A collection of cursors
  class Region
    def initialize(cursors)
      @region = cursors
    end

    def neighbors(wrap: false)
      (@region.flat_map { |cursor| cursor.neighbors(wrap:) }.uniq - @region).sort
    end

    def include?(cursor)
      @region.include?(cursor)
    end

    def to_s
      @region.map(&:to_s).join
    end
  end
end
