require 'minitest/autorun'
require 'active_record'
require 'migration_data'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'tmp/test.sqlite3')