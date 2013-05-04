# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'future_proof/version'

Gem::Specification.new do |spec|
  spec.name          = 'future_proof'
  spec.version       = FutureProof::VERSION
  spec.authors       = ['Nikita Cernovs']
  spec.email         = ['nikita.cernovs@gmail.com']
  spec.description   = %q{Ruby concurrency extenstions}
  spec.summary       = %q{Ruby concurrency extenstions}
  spec.homepage      = 'http://nikitachernov.github.io/FutureProof'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rake'
end
