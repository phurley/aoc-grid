# frozen_string_literal: true

require "spec_helper"

RSpec.describe Aoc::Grid do
  subject(:grid) { Aoc::Grid.new(10, 10, default: ".") }

  it "has a version number" do
    expect(Aoc::Grid::VERSION).not_to be nil
  end

  context "basic grid" do
    it "has a width and height" do
      expect(subject.width).to eq(10)
      expect(subject.height).to eq(10)
    end

    it "has a default value" do
      expect(subject.at(0, 0)).to eq(".")
    end

    it "can be indexed" do
      expect(subject[0, 0]).to eq(".")
    end

    it "can be mutated" do
      expect(subject[0, 0]).to eq(".")
      subject[0, 0] = "X"
      expect(subject[0, 0]).to eq("X")
      expect(subject[1, 1]).to eq(".")
    end

    it "knows if a coordinate is valid" do
      expect(subject.valid?(0, 0)).to be true
      expect(subject.valid?(9, 9)).to be true
      expect(subject.valid?(10, 10)).to be false
      expect(subject.valid?(-1, -1)).to be false
    end
  end
end
