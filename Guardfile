# frozen_string_literal: true

guard :rspec, cmd: "bundle exec rspec" do
  watch(%r{^spec/.+_spec\.rb$}) { "spec" }
  watch(%r{^lib/(.+)\.rb$})     { "spec" }
  watch("spec/spec_helper.rb")  { "spec" }
end
