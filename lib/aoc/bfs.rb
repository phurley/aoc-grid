# frozen_string_literal: true

require "set"

module Aoc
  # A grid is a two dimensional array of values.  The grid is indexed by
  class BFS
    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/PerceivedComplexity
    def self.solve(from, to, directions, &valid)
      options = from.restricted_neighbors(directions).select { |pos| valid.call(pos, [from]) }.map { |pos| [from, pos] }
      visited = Set.new
      visited.add(from)

      while options.any?
        path = options.shift
        return path if path.last == to

        node = path.last
        next if visited.include?(node)

        visited.add(node)
        options += node.restricted_neighbors(directions)
                       .select { |pos| !visited.include?(pos) && valid.call(pos, path) }
                       .map { |pos| [*path, pos] }
      end

      []
    end
    # rubocop:enable Metrics/PerceivedComplexity
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/AbcSize
  end
end