# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cocoapods/ack_filter/version'

Gem::Specification.new do |spec|
  spec.name          = "cocoapods-ack_filter"
  spec.version       = Cocoapods::AckFilter::VERSION
  spec.authors       = ["Yusuke Mito"]
  spec.email         = ["y310.1984@gmail.com"]
  spec.summary       = 'Filter out licenses with pattern from Pods-acknowledgements.plist'
  spec.description   = 'Filter out licenses with pattern from Pods-acknowledgements.plist'
  spec.homepage      = "https://github.com/y310/cocoapods-ack_filter"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'cocoapods', '~> 0.33'
  spec.add_runtime_dependency 'CFPropertyList', '>= 2.2'
  spec.add_runtime_dependency 'libxml-ruby', '>= 2.6'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
