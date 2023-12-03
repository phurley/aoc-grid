# frozen_string_literal: true

require "spec_helper"

PUZZLE_INPUT = <<~INPUT
  467..114..
  ...*......
  ..35..633.
  ......#...
  617*......
  .....+.58.
  ..592.....
  ......755.
  ...$.*....
  .664.598..
INPUT

RSpec.describe Aoc::Grid do
  subject(:grid) { Aoc::Grid.from_string(PUZZLE_INPUT) }
  let(:numbers) { subject.find_horizontal_regions(/\d/) }
  let(:number_list) { numbers.map(&:to_s) }

  context "puzzle grid" do
    it "has a width and height" do
      expect(subject.width).to eq(10)
      expect(subject.height).to eq(10)
    end

    it "has numeric regions" do
      expect(numbers.size).to eq(10)
    end

    it "can generate a list of numbers" do
      expect(number_list).to eq(%w[467 114 35 633 617 58 592 755 664 598])
    end
  end
end
