# OFX

[![Gem Version](https://badge.fury.io/rb/ofx.svg)](https://badge.fury.io/rb/ofx)

A simple OFX (Open Financial Exchange) parser built on top of Nokogiri.
Currently supports both OFX 1.0.2, 1.0.3 and 2.1.1.

Works on ruby 2.3.

## Usage

``` ruby
require "ofx"

OFX("file.ofx") do
  p account
  p account.balance
  p account.transactions
end
```

Invalid files will raise an OFX::UnsupportedFileError.

## Creator

- Nando Vieira - [simplesideias.com.br](http://simplesideias.com.br)

## Maintainer

- Anna Cruz - [anna-cruz.com](http://anna-cruz.com)

## License

(The MIT License)

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
