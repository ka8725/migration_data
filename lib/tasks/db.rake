require 'migration_data/squash'

namespace :db do
  namespace :migrate do
    desc 'Squashes all current migrations and dumps current schema to the latest one'
    task :squash => 'db:load_config' do
      ::ActiveRecord::Base.establish_connection
      MigrationData::Squash.new.call
    end
  end
end
