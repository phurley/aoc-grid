# frozen_string_literal: true

require "aoc/grid"

puts Dir.pwd
fname = ARGV.first
puts fname
g = Aoc::Grid.from_file(fname)
start = g.cursor(1, 1)
stop = g.cursor(8, 8)

path = Aoc::BFS.solve(start, stop, Aoc::Cursor::DIRECTIONS) { |pos| pos.to_s == " " }
puts g

svg_frame0 = g.to_svg_object(id: "frame0", klass: "grid")

svg = Victor::SVG.new
svg << svg_frame0.render(template: :html)
path.each_with_index do |cursor, i|
  g[cursor.x, cursor.y] = "*"
  frame = g.to_svg_object(id: "frame#{i + 1}", klass: "grid")
  svg << frame.render(template: :html)
end

template_fname = __FILE__.gsub("bfs_test.rb", "animate.html")
svg.save("fun.html", template: template_fname)
