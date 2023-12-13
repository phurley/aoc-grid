# frozen_string_literal: true

require "spec_helper"

RSpec.describe Aoc::SparseGrid do
  subject(:grid) { described_class.new(10, 10, default: ".") }

  context "with a sparse grid" do
    it "has a width" do
      expect(grid.width).to eq(10)
    end

    it "has a height" do
      expect(grid.height).to eq(10)
    end

    it "has a default value" do
      expect(grid.at(0, 0)).to eq(".")
    end

    it "can be indexed" do
      expect(grid[0, 0]).to eq(".")
    end

    it "can be mutated" do
      expect(grid[0, 0]).to eq(".")
      grid[0, 0] = "X"
      expect(grid[0, 0]).to eq("X")
      expect(grid[1, 1]).to eq(".")
    end

    it "knows if a coordinate is valid" do
      expect(grid.valid?(0, 0)).to be true
      expect(grid.valid?(9, 9)).to be true
      expect(grid.valid?(10, 10)).to be false
      expect(grid.valid?(-1, -1)).to be false
    end

    it "can add a row" do
      expect(grid.height).to eq(10)
      expect(grid[0, 3]).to eq(".")
      grid.add_row(3, default: "X")
      expect(grid[0, 3]).to eq("X")
      expect(grid.height).to eq(11)
    end

    it "can add a column" do
      expect(grid.width).to eq(10)
      expect(grid[3, 0]).to eq(".")
      grid.add_column(3, default: "X")
      expect(grid[3, 0]).to eq("X")
      expect(grid.width).to eq(11)
    end

    it "is enumerable" do
      expect(grid.each).to be_a(Enumerator)
    end
  end
end
