require_relative 'lib/treely/version'

Gem::Specification.new do |spec|
  spec.name     = 'treely'
  spec.version  = Treely::VERSION
  spec.licenses = ['BSD-1-Clause']
  spec.homepage = 'https://dub.sh/treely'
  spec.summary  = 'A gem for generating tree-like format'
  spec.author   = 'oneureka'
  spec.email    = 'oneureka@github.io'
  spec.files    = Dir['lib/**/*.rb']

  spec.executables = ['treely']
  spec.required_ruby_version = '>= 3.0'
end
