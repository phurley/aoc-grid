module Aoc
  # A collection of cursors
  class Region # rubocop:disable Metrics/ClassLength
    include Comparable

    def initialize(cursors)
      @region = Set.new(cursors)
    end

    def grid
      @region.first&.grid
    end

    def add!(cursor)
      @region.add(cursor)
    end

    def to_set
      @region
    end

    def <=>(other)
      @region <=> other.to_a
    end

    def eql?(other)
      @region.eql?(other.to_set)
    end

    def hash
      @region.hash
    end

    def neighbors(wrap: false)
      Set.new(@region.flat_map { |cursor| cursor.neighbors(wrap:) }) - @region.to_a
    end

    def include?(cursor)
      @region.include?(cursor)
    end

    def size
      @region.size
    end

    def to_a
      @region.to_a
    end

    def merge(other)
      Region.new(@region.clone.merge(other.to_set))
    end

    def clone
      Region.new(@region)
    end

    def -(other)
      Region.new(@region - other.to_set)
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
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/PerceivedComplexity
    def fill!(from: " ", to: "#")
      # find bounding box
      bb = bounding_box
      grid = @region.first.grid

      # find interior (by BFS exterior around bounding box)
      exterior = Set.new
      (bb.top..bb.bottom).each do |y|
        [bb.left, bb.right].each do |x|
          next if exterior.include?([x, y])
          next unless from === grid[x, y]

          BFS.visit(grid.cursor(x, y)) { |cursor| from === cursor.get && bb.include?(cursor) }.each do |pos|
            next if exterior.include?(pos)

            exterior.add(pos)
          end
        end
      end

      pp exterior
      interior = @region - exterior
      # fill interior
      interior.each do |cursor|
        cursor.neighbors.each do |neighbor|
          next if exterior.include?(neighbor)

          BFS.visit(neighbor) { |c| from === c.get }.each do |pos|
            grid[pos.x, pos.y] = to
          end
        end
      end
    end
    # rubocop:enable Style/CaseEquality
    # rubocop:enable Metrics/PerceivedComplexity
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize

    def apply(fn)
      @region.each { |cursor| cursor.set(fn.call(cursor)) }
    end

    def clear_non_region(value: " ")
      grid = @region.first.grid
      bb = bounding_box
      (bb.top..bb.bottom).each do |y|
        (bb.left..bb.right).each do |x|
          grid[x, y] = value unless @region.include?(grid.cursor(x, y))
        end
      end
    end

    def to_s
      result = ""
      grid = @region.first.grid
      bb = bounding_box
      (bb.top..bb.bottom).each do |y|
        (bb.left..bb.right).each do |x|
          result << grid[x, y]
        end
        result << "\n"
      end

      result.chomp
    end
  end
end
