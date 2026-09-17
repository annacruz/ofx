require "simplecov"
SimpleCov.start do
  enable_coverage :branch
  add_filter "/spec/"
  minimum_coverage line: 99, branch: 87
end

require "ofx"
require "byebug"

RSpec::Matchers.define :have_key do |key|
  match do |hash|
    hash.respond_to?(:keys) &&
    hash.keys.kind_of?(Array) &&
    hash.keys.include?(key)
  end
end

RSpec.configure do |c|
  c.filter_run_when_matching :focus
end
