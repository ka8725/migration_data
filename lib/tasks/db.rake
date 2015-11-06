require 'migration_data'
require 'migration_data/squash'

namespace :db do
  namespace :migrate do
    desc 'Squashes all old migrations and dumps current schema to the latest one'
    task :squash => :environment do
      MigrationData::Squash.new.call
    end
  end
end
