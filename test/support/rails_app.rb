class RailsApp < Rails::Application
end

Rails.application.config.root = 'test/rails_app'

FileUtils.mkdir_p(Rails.application.config.root.join('db', 'migrate'))
