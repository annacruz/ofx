# frozen_string_literal: true

# Builds a Markdown report of the SimpleCov run for a pull request comment.
# Usage: ruby .github/scripts/coverage_comment.rb [coverage/.resultset.json] [coverage/rspec.json]
#
# Exit status tells the caller what to do with the output:
#   EXIT_FULLY_COVERED (0)          every line and branch under lib/ is covered; nothing to post
#   EXIT_UNCOVERED_CODE (10)        stdout holds the report of uncovered code; post it
#   EXIT_COVERAGE_NOT_MEANINGFUL (11) the suite did not finish or had failures; ignore coverage

require 'json'

MARKER = '<!-- simplecov-report -->'
EXIT_FULLY_COVERED = 0
EXIT_UNCOVERED_CODE = 10
EXIT_COVERAGE_NOT_MEANINGFUL = 11

def pct(covered, total)
  return '100.0%' if total.zero?

  format('%.1f%%', covered * 100.0 / total)
end

path = ARGV.fetch(0, 'coverage/.resultset.json')
rspec_path = ARGV.fetch(1, 'coverage/rspec.json')

unless File.exist?(rspec_path)
  warn "#{rspec_path} not found: the suite did not finish, skipping the coverage report"
  exit EXIT_COVERAGE_NOT_MEANINGFUL
end

summary = JSON.parse(File.read(rspec_path)).fetch('summary')
failures = summary.fetch('failure_count') + summary.fetch('errors_outside_of_examples_count')
unless failures.zero?
  warn "#{failures} failing example(s): coverage is not meaningful, skipping the coverage report"
  exit EXIT_COVERAGE_NOT_MEANINGFUL
end

coverage = JSON.parse(File.read(path)).values.first.fetch('coverage')
root = "#{Dir.pwd}/"

lines_total = lines_hit = branches_total = branches_hit = 0
gaps = []

coverage.sort.each do |file, data|
  next unless file.include?('/lib/')

  lines = data.fetch('lines').compact
  lines_total += lines.size
  lines_hit += lines.count(&:positive?)
  missed_lines = data.fetch('lines').each_index.select { |i| data['lines'][i]&.zero? }.map { |i| i + 1 }

  branches = data.fetch('branches', {}).values.flat_map(&:values)
  branches_total += branches.size
  branches_hit += branches.count(&:positive?)
  missed_branches = data.fetch('branches', {}).sum { |_, targets| targets.values.count(&:zero?) }

  next if missed_lines.empty? && missed_branches.zero?

  gaps << [file.delete_prefix(root), missed_lines, missed_branches]
end

exit EXIT_FULLY_COVERED if gaps.empty?

puts MARKER
puts '## Test coverage'
puts
puts '| | Covered | Total | |'
puts '|--|--:|--:|--:|'
puts "| Lines | #{lines_hit} | #{lines_total} | #{pct(lines_hit, lines_total)} |"
puts "| Branches | #{branches_hit} | #{branches_total} | #{pct(branches_hit, branches_total)} |"
puts
puts '### Not covered'
puts
puts '| File | Lines | Branches |'
puts '|--|--|--:|'
gaps.each do |file, lines, branches|
  puts "| `#{file}` | #{lines.empty? ? '—' : lines.join(', ')} | #{branches} |"
end
exit EXIT_UNCOVERED_CODE
