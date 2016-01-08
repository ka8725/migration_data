# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'migration_data/version'

Gem::Specification.new do |spec|
  spec.name          = "migration_data"
  spec.version       = MigrationData::VERSION
  spec.authors       = ["Andrey Koleshko"]
  spec.email         = ["ka8725@gmail.com"]
  spec.summary       = %q{Provides possibility to write any code in migrations safely without regression.}
  spec.description   = %q{Sometimes we have to write some Rails code in the migrations and it's hard to
                          keep them in working state because models wich are used there changes too often. there
                          some techniques which help to avoid these pitfalls. For example, define model
                          classes in the migrations or write raw SQL. But they don't help in 100% cases anyway.
                          This gem promises to solve the problem in a simple way.}
  spec.homepage      = "http://railsguides.net/change-data-in-migrations-like-a-boss/"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'sqlite3'
end
