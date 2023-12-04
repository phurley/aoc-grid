# frozen_string_literal: true

require "spec_helper"

RSpec.describe Aoc::Cursor do
  subject(:cursor) { grid.cursor(0, 0) }

  let(:grid) { Aoc::Grid.new(10, 10, default: ".") }

  context "with a basic grid" do
    it "can be created" do
      expect(cursor).to be_a(described_class)
      expect(cursor.x).to eq(0)
      expect(cursor.y).to eq(0)
    end

    it "can find neighbors" do
      neighbors = cursor.neighbors
      expect(neighbors.size).to eq(3)
      expect(neighbors).to include(grid.cursor(0, 1))
      expect(neighbors).to include(grid.cursor(1, 0))
      expect(neighbors).to include(grid.cursor(1, 1))
      expect(neighbors).not_to include(grid.cursor(0, 0))
      expect(neighbors).not_to include(grid.cursor(2, 2))
    end

    it "can be hashed" do
      expect(cursor.hash).to be_a(Integer)
      cursor2 = grid.cursor(0, 0)
      hash = {}
      hash[cursor] = 1
      hash[cursor2] = 2
      expect(hash.size).to eq(1)
    end
  end
end
