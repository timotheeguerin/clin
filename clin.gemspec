# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'clin/version'

Gem::Specification.new do |spec|
  spec.name = 'clin'
  spec.version = Clin::VERSION
  spec.authors = ['Timothee Guerin']
  spec.email = ['timothee.guerin@outlook.com']
  spec.summary = %q{Clin provide an advance way to define complex command line interface.}
  spec.description = %q{Write a longer description. Optional.}
  spec.homepage = ''
  spec.license = 'MIT'

  spec.files = `git ls-files -z`.split("\x0")
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '>=4.0'
  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'coveralls'

end
