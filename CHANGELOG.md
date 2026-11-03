# Changelog

All notable changes to this project are documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [1.0.0] - Unreleased

### Removed

- The deprecated `OFX::Parser::OFX102#account` method, also inherited by
  `OFX::Parser::OFX211`. It silently ignored every account after the first.
  Use `accounts` and select the desired account explicitly. See #91.
- Passing a URL string to `OFX()` or `OFX::Parser::Base.new`. It had not worked
  since Ruby 3.0 removed URL support from `Kernel#open`; download the file and
  pass its content or an IO instead (#166).

### Changed

- README migrated from RDoc to Markdown, with a Disclaimer section; the MIT
  text moved to a `LICENSE` file, which is now packaged with the gem.

### Security

- The parser no longer calls `Kernel#open` on its argument, which executed a
  shell command when the string started with `|`. Existing file paths are
  opened with `File.open`; anything else is treated as OFX content (#166).

### Added

- Explicit `bigdecimal` and `nkf` runtime dependencies so the gem loads on
  Ruby 3.4, plus Ruby 3.4 in the CI matrix (#150).
- RuboCop in CI with a baseline of existing offenses (#151, #155).
- Development section in the README (#152).
