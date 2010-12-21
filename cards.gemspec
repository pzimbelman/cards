# -*- encoding: utf-8 -*-
 
Gem::Specification.new do |s|
  s.name        = "cards"
  s.version     = "0.1.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Peter Zimbelman"]
  s.email       = ["pzimbelman@gmail.com"]
  s.homepage    = "http://github.com/pzimbelman/cards"
  s.summary     = "A cards library."
  s.description = "A simple library to allow the use of a deck of cards and the creation and comparison of poker hands from these cards."
 
  s.required_rubygems_version = ">= 1.3.6"
 
  s.files        = Dir.glob("{lib}/**/*")
  s.require_path = 'lib'
end
