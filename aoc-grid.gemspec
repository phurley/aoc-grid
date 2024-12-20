# frozen_string_literal: true

require_relative "lib/aoc/version"

Gem::Specification.new do |spec|
  spec.name = "aoc-grid"
  spec.version = Aoc::Grid::VERSION
  spec.authors = ["Patrick Hurley"]
  spec.email = ["phurley@invoca.com"]

  spec.summary = "Handy grid datatype for use in advent of code challenges."
  spec.description = "Handy grid datatype for use in advent of code challenges."
  spec.homepage = "https://github.com/phurley/aoc-grid"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/phurley/aocgrid/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "victor", "> 0.3.4"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata["rubygems_mfa_required"] = "true"
end
