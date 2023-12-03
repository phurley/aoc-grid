module Aoc
  class Region
    def initialize(cursors)
      @region = cursors
    end

    def neighbors(wrap: false)
      (@region.flat_map { |cursor| cursor.neighbors(wrap: wrap) }.uniq - @region).sort
    end

    def include?(cursor)
      @region.include?(cursor)
    end

    def to_s
      @region.map { |cursor| cursor.to_s }.join
    end
  end
end
