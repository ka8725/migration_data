require 'yaml'

class RailsApp < Rails::Application
end

Rails.application.config.root = 'test/rails_app'

db_config = YAML.load_file(Rails.application.config.root.join('config', 'database.yml'))
::ActiveRecord::Tasks::DatabaseTasks.database_configuration = db_config

FileUtils.mkdir_p(Rails.application.config.root.join('db', 'migrate'))
