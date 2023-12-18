# frozen_string_literal: true

require "set"

module Aoc
  # A grid is a two dimensional array of values.  The grid is indexed by
  class BFS
    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/PerceivedComplexity
    def self.solve(from, to, directions)
      options = from.restricted_neighbors(directions).select { |pos| yield(pos, [from]) }.map { |pos| [from, pos] }
      visited = Set.new
      visited.add(from)

      while options.any?
        path = options.shift
        return path if path.last == to

        node = path.last
        next if visited.include?(node)

        visited.add(node)
        options += node.restricted_neighbors(directions)
                       .select { |pos| !visited.include?(pos) && yield(pos, path) }
                       .map { |pos| [*path, pos] }
      end

      []
    end

    def self.visit(start, directions = Aoc::Cursor::DIRECTIONS)
      options = [start]
      visited = Set.new

      while options.any?
        node = options.shift
        next if visited.include?(node)
        next if block_given? && !yield(node)

        visited.add(node)
        options += node.restricted_neighbors(directions).select do |pos|
          block_given? ? yield(pos) : true
        end
      end

      visited
    end
    # rubocop:enable Metrics/PerceivedComplexity
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/AbcSize
  end
end
