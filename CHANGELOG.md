# Changelog

All notable changes to this project are documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [1.0.0] - Unreleased

### Removed

- The deprecated `OFX::Parser::OFX102#account` method, also inherited by
  `OFX::Parser::OFX211`. It silently ignored every account after the first.
  Use `accounts` and select the desired account explicitly. See #91.

### Added

- Explicit `bigdecimal` and `nkf` runtime dependencies so the gem loads on
  Ruby 3.4, plus Ruby 3.4 in the CI matrix (#150).
- RuboCop in CI with a baseline of existing offenses (#151, #155).
- Development section in the README (#152).
