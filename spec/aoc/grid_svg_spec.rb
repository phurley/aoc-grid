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
  subject(:grid) { described_class.from_string(PUZZLE_INPUT) }

  context "with a puzzle grid generate svg" do
    let(:svg) { grid.to_svg_object }
    let(:svg_string) { svg.render }

    it "can create svg" do
      expect(svg_string).to be_a(String)
      expect(svg_string).to include("<svg")
    end
  end
end
