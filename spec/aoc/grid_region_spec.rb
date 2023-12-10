# frozen_string_literal: true

require "spec_helper"

RSpec.describe Aoc::Grid do
  subject(:grid) { described_class.from_string(puzzle_input) }

  let(:puzzle_input) do
    input = <<~INPUT
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
    input.each_line.map(&:strip).join("\n")
  end

  context "with a puzzle grid" do
    let(:numbers) { subject.find_horizontal_regions(/\d/) }
    let(:number_list) { numbers.map(&:to_s) }

    it "has a width and height" do
      expect(grid.width).to eq(10)
      expect(grid.height).to eq(10)
    end

    it "has numeric regions" do
      expect(numbers.size).to eq(10)
    end

    it "can generate a list of numbers" do
      expect(number_list).to eq(%w[467 114 35 633 617 58 592 755 664 598])
    end
  end

  context "with a vertical puzzle grid" do
    let(:numbers) { subject.find_vertical_regions(/\d/) }
    let(:number_list) { numbers.map(&:to_s) }

    it "has numeric regions" do
      expect(numbers.size).to eq(28)
    end

    it "can merge regions" do
      r1, r2 = numbers.take(2)
      merged = r1.merge(r2)
      expect(merged.to_a.join).to eq("46")
    end
  end
end
