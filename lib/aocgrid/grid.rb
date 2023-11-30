module Aoc
    class Grid
        def initialize(width, height, default: nil, &block)
            @width = width
            @height = height
            if block_given?
                @grid = Array.new(height) { |x| Array.new(width) { |y| block.call(x,y) } }
            else
                
            @grid = Array.new(height) { Array.new(width, default) }
            end
        end
    end
end
