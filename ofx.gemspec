# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ofx/version"

Gem::Specification.new do |s|
  s.name        = "ofx"
  s.version     = OFX::Version::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Nando Vieira", "Anna Cruz"]
  s.email       = ["fnando.vieira@gmail.com", "anna.cruz@gmail.com"]
  s.homepage    = "http://rubygems.org/gems/ofx"
  s.summary     = "A simple OFX (Open Financial Exchange) parser built on top of Nokogiri. Currently supports OFX 102, 200 and 211."
  s.description = <<-TXT
A simple OFX (Open Financial Exchange) parser built on top of Nokogiri.
Currently supports OFX 102, 200 and 211.

Usage:

  OFX("sample.ofx") do |ofx|
    p ofx
  end
TXT

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "nokogiri"
  s.add_development_dependency "rspec", "~> 2.7"
  s.add_development_dependency "rake"
  s.add_development_dependency "pry"
  s.add_development_dependency "pry-debugger"
end
