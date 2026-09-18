# frozen_string_literal: true

# Builds a Markdown report of the SimpleCov run for a pull request comment.
# Usage: ruby .github/scripts/coverage_comment.rb [coverage/.resultset.json] [coverage/rspec.json]
#
# Exit status: 0 when every line and branch is covered; 10 when the report
# lists uncovered code and should be posted; 11 when the suite did not
# finish or had failing examples, so coverage is not meaningful.

require 'json'

MARKER = '<!-- simplecov-report -->'
REPORT = 10
SKIPPED = 11

def pct(covered, total)
  return '100.0%' if total.zero?

  format('%.1f%%', covered * 100.0 / total)
end

path = ARGV.fetch(0, 'coverage/.resultset.json')
rspec_path = ARGV.fetch(1, 'coverage/rspec.json')

unless File.exist?(rspec_path)
  warn "#{rspec_path} not found: the suite did not finish, skipping the coverage report"
  exit SKIPPED
end

summary = JSON.parse(File.read(rspec_path)).fetch('summary')
failures = summary.fetch('failure_count') + summary.fetch('errors_outside_of_examples_count')
unless failures.zero?
  warn "#{failures} failing example(s): coverage is not meaningful, skipping the coverage report"
  exit SKIPPED
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

exit 0 if gaps.empty?

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
exit REPORT
