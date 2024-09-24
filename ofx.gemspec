$:.push File.expand_path('lib', __dir__)
require 'ofx/version'

Gem::Specification.new do |s|
  s.name        = 'ofx'
  s.version     = OFX::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Nando Vieira', 'Anna Cruz']
  s.email       = ['fnando.vieira@gmail.com', 'anna.cruz@gmail.com']
  s.homepage    = 'http://rubygems.org/gems/ofx'
  s.summary     = 'A simple OFX (Open Financial Exchange) parser built on top of Nokogiri. Currently supports OFX 102, 200 and 211.'
  s.description = <<~TXT
    A simple OFX (Open Financial Exchange) parser built on top of Nokogiri.
    Currently supports OFX 102, 200 and 211.

    Usage:

      OFX('sample.ofx') do |ofx|
        p ofx
      end
  TXT

  s.files         = Dir['lib/**/*.rb', 'spec/**/*.rb', 'README.rdoc', 'Rakefile']
  s.require_paths = ['lib']
  s.licenses      = ['MIT']

  s.add_dependency 'nokogiri', '~> 1.14.5'
  s.add_dependency 'nkf', '0.2.0'
  s.add_dependency 'bigdecimal', '3.1.8'
  s.add_development_dependency 'byebug', '11.1.3'
  s.add_development_dependency 'rake', '13.2.1'
  s.add_development_dependency 'rspec', '3.13.0'
  s.add_development_dependency 'guard', '2.18.1'
  s.add_development_dependency 'guard-rspec', '4.7.3'
end
