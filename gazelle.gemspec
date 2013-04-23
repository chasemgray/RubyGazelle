# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gazelle/version'

Gem::Specification.new do |spec|
  spec.name          = "gazelle"
  spec.version       = RubyGazelle::VERSION
  spec.authors       = ["Chasemgray, Aaron Neyer"]
  spec.email         = ["aaronneyer@gmail.com"]
  spec.description   = %q{Wrapper around what.cd Gazelle API}
  spec.summary       = %q{Used to interface with what.cd}
  spec.homepage      = "http://github.com/chasemgray/RubyGazelle"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_dependency "httparty"
  spec.add_dependency "json"
  spec.add_dependency "recursive-open-struct"

end
