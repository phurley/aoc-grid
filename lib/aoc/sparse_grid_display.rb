# frozen_string_literal: true

require "victor"

require_relative "cursor"
require_relative "bfs"

module Aoc
  # A grid is a two dimensional array of values.  The grid is indexed by
  class SparseGrid
    include Enumerable

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
      result = +""
      width.times do |x|
        height.times do |y|
          result << cursor(x, y).to_s
        end
        result << "\n"
      end
      result
    end

    def to_svg_object(grid_size: 10, margin: 10, klass: "grid", id: nil)
      Victor::SVG.new(class: klass, id:,
                      width: (@width * grid_size) + (margin * 2),
                      height: (@height * grid_size) + (margin * 2)).tap do |svg|
        width.times do |x|
          height.times do |y|
            next if cursor(x, y).to_s == " "

            svg_place_item(svg, cursor(x, y), grid_size, margin)
          end
        end
      end
    end

    def to_svg(fname, grid_size: 10, margin: 10, klass: "grid", id: nil)
      svg = to_svg_object(grid_size:, margin:, klass:, id:)
      svg.save(fname)
    end

    private

    def svg_place_item(svg, cursor, grid_size, margin)
      svg.text cursor.to_s, x: (cursor.x * grid_size) + margin, y: (cursor.y * grid_size) + margin,
                            font_size: grid_size
    end
  end
end
