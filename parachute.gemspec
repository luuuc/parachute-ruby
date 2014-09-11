# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'parachute/version'

Gem::Specification.new do |spec|
  spec.name          = "parachute"
  spec.version       = Parachute::VERSION
  spec.authors       = ["Luc Perussault"]
  spec.email         = ["luc@codedynamic.com"]
  spec.summary       = "Parachute Exception notifications ruby client"
  spec.description   = "Send exception notifications to your Parachute server"
  spec.homepage      = "https://github.com/luuuc/parachute-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", ">= 3.0.4"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
