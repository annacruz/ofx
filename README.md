# OFX

[![Gem Version](https://badge.fury.io/rb/ofx.svg)](https://badge.fury.io/rb/ofx)
[![Build Status](https://github.com/annacruz/ofx/actions/workflows/config.yml/badge.svg)](https://github.com/annacruz/ofx/actions)

A simple OFX (Open Financial Exchange) parser built on top of Nokogiri. Currently supports both OFX 1.0.2 and 2.1.1.

Works on both ruby 1.9 and 2.0.

## Usage

```ruby
require "ofx"

OFX("file.ofx") do
  p account
  p account.balance
  p account.transactions
end
```

Invalid files will raise an OFX::UnsupportedFileError.


## Deploy

1. Create and send the new version to Rubygems

```ruby
bundle exec rake release
```

2. Create a [new release on Github](https://github.com/annacruz/ofx/releases/new)

* Choose **the new tag** (Ex.: v0.10.1)
* Fill the **Release title** (Ex.: 0.10.1)
* Click at **Generate release notes**
* Click at **Publish release**

3. Done!

## Creator

* Nando Vieira - http://simplesideias.com.br

## Maintainer

* Anna Cruz - http://anna-cruz.com

## License

(The MIT License)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the 'Software'), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
