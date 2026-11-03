# OFX

[![Gem Version](https://badge.fury.io/rb/ofx.svg)](https://badge.fury.io/rb/ofx)
[![Build Status](https://github.com/annacruz/ofx/actions/workflows/config.yml/badge.svg)](https://github.com/annacruz/ofx/actions)

A simple OFX (Open Financial Exchange) parser built on top of Nokogiri. Supports OFX 1.x (SGML) and 2.x (XML); see [Supported OFX versions](#supported-ofx-versions) below.

Requires Ruby 3.1 or newer.

## Disclaimer

This gem is provided "as is", without warranty of any kind, under the [MIT License](LICENSE). It parses financial statements, so validate its output before relying on it: the authors and maintainers are not liable for any loss or damage arising from its use.

## Usage

```ruby
require "ofx"

OFX("file.ofx") do
  p accounts
  p accounts.first.balance
  p accounts.first.transactions
end
```

Invalid files will raise an `OFX::UnsupportedFileError`.

## Supported OFX versions

OFX 1.0.0, 1.0.2, and 1.0.3 are parsed as SGML. OFX 2.0.0, 2.0.2,
2.1.1, and 2.2.0 are parsed as XML. The parser supports bank and credit-card
statements; investment statements and other OFX aggregates are not supported.

## Development

Install the dependencies and run the test suite:

```sh
bundle install
bundle exec rspec
```

To run relevant specs automatically when files under `lib/` or `spec/` change:

```sh
bundle exec guard
```

Run the code-quality checks with:

```sh
bundle exec rubocop
```

## Releasing

Only the gem owners on RubyGems can publish. The steps, in order:

1. Move the "Unreleased" entry in `CHANGELOG.md` to the new version and date.
2. Bump `OFX::VERSION` in `lib/ofx/version.rb` and run `bundle install` to refresh `Gemfile.lock`.
3. Open a pull request with those changes and merge it into `main`.
4. On an up-to-date `main`, run:

   ```sh
   bundle exec rake release
   ```

   It builds the gem, creates and pushes the `vX.Y.Z` tag, and publishes to RubyGems.
5. Create a [GitHub release](https://github.com/annacruz/ofx/releases/new) from that tag and paste the changelog entry as the notes.

## Creator

- Nando Vieira - http://simplesideias.com.br

## Maintainer

- Anna Cruz - http://anna-cruz.com

## License

MIT, see [LICENSE](LICENSE).
