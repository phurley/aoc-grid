# frozen_string_literal: true

require_relative "grid_base"
require_relative "grid_display"
require_relative "grid_util"
require_relative "sparse_grid_base"
require_relative "sparse_grid_display"
require_relative "sparse_grid_util"
require_relative "cursor"
require_relative "cursor_support"
require_relative "region"
require_relative "bounding_box"
require_relative "bfs"
require_relative "version"

module Aoc
  class Error < StandardError; end
end
