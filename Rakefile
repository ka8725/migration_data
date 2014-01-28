require "bundler/gem_tasks"


require 'rake/testtask'

desc 'Default: run unit tests.'
task default: :test

desc 'Test the migration_data plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end
