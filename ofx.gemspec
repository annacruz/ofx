# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ofx/version"

Gem::Specification.new do |s|
  s.name        = "ofx"
  s.version     = OFX::Version::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Nando Vieira"]
  s.email       = ["fnando.vieira@gmail.com"]
  s.homepage    = "http://rubygems.org/gems/ofx"
  s.summary     = "A simple OFX (Open Financial Exchange) parser built on top of Nokogiri. Currently supports OFX 1.0.2."
  s.description = <<-TXT
A simple OFX (Open Financial Exchange) parser built on top of Nokogiri.
Currently supports OFX 1.0.2.

Usage:

  OFX("sample.ofx") do |ofx|
    p ofx
  end
TXT

  s.rubyforge_project = "ofx"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "nokogiri"
  s.add_development_dependency "rspec", ">= 2.0.0"
end
