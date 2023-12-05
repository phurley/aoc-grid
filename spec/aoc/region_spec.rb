# frozen_string_literal: true

require "spec_helper"

RSpec.describe Aoc::Region do
  subject(:region) { described_class.new([grid.cursor(0, 0)]) }

  let(:grid) { Aoc::Grid.from_file("spec/fixtures/square.txt") }

  context "with a basic grid" do
    it "can be created" do
      expect(region).to be_a(described_class)
      expect(region.size).to eq(1)
    end

    it "can be added to" do
      region.add!(grid.cursor(1, 1))
      expect(region.size).to eq(2)
    end

    it "can find neighbors" do
      neighbors = region.neighbors
      expect(neighbors.size).to eq(3)
      expect(neighbors).to include(grid.cursor(0, 1))
      expect(neighbors).to include(grid.cursor(1, 0))
      expect(neighbors).to include(grid.cursor(1, 1))
      expect(neighbors).not_to include(grid.cursor(0, 0))
      expect(neighbors).not_to include(grid.cursor(2, 2))
    end

    it "can be hashed" do
      expect(region.hash).to be_a(Integer)
      region2 = described_class.new([grid.cursor(0, 0)])
      hash = {}
      hash[region] = 1
      hash[region2] = 2
      expect(hash.size).to eq(1)
    end

    it "can be merged" do
      region2 = described_class.new([grid.cursor(1, 1)])
      region3 = region.merge(region2)
      expect(region3.size).to eq(2)
    end

    it "can find a bounding box" do
      region = described_class.new([grid.cursor(2, 2), grid.cursor(6, 3), grid.cursor(2, 5)])
      bound_box = region.bounding_box

      expect(bound_box.top).to eq(2)
      expect(bound_box.bottom).to eq(5)
      expect(bound_box.left).to eq(2)
      expect(bound_box.right).to eq(6)
    end

    it "can be filled" do
      region = Aoc::BoundingBox.new(2, 2, 6, 6).to_region(grid)
      region.fill!(from: " ", to: "#")
      expect(grid[1, 1]).to eq(" ")
      expect(grid[2, 2]).to eq("X")
      expect(grid[3, 3]).to eq("#")
    end
  end
end
