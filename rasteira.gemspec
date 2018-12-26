# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rasteira/version'

Gem::Specification.new do |spec|
  spec.name          = 'rasteira'
  spec.version       = Rasteira::VERSION
  spec.authors       = ['Kazuhiro Serizawa']
  spec.email         = ['nserihiro@gmail.com']

  spec.summary       = 'simple, on memory, and thread base job queue worker'
  spec.description   = 'simple, on memory, and thread base job queue worker'
  spec.homepage      = 'https://github.com/serihiro/rasteira'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r(^exe/)) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.3'

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '0.61.1'
  spec.add_development_dependency 'yard'
end
