require 'minitest/autorun'
require 'migration_data'
require 'rails'

Dir[File.join(File.dirname(__FILE__), 'support', '**/*.rb')].each { |f| require f }

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'tmp/test.sqlite3')

FORCE_MIGRATION = if ActiveRecord.version < Gem::Version.new('4.2.0.rc1')
                    'true'
                  else
                    ':cascade'
                  end
