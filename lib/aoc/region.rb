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
  end
end
