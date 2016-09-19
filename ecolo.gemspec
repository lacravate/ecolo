$:.unshift File.expand_path('../lib', __FILE__)
require 'ecolo/version'

Gem::Specification.new do |s|
  s.name          = "ecolo"
  s.version       = Ecolo::VERSION
  s.authors       = ["lacravate"]
  s.email         = ["lacravate@lacravate.fr"]
  s.homepage      = "https://github.com/lacravate/ecolo"
  s.summary       = "Expert in simple environmental concerns"
  s.description   = "A few lines of code to give your top level module (or class) the env getter and setter"

  s.files         = `git ls-files app lib`.split("\n")
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']

  s.add_development_dependency 'rspec', "~> 3.5"
  s.add_development_dependency 'pry', "~> 0.10.4"
end
