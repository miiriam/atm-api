require 'yaml'
require 'sinatra/activerecord'
require './app'

task :environment do
  db_config = YAML.safe_load(File.read('config/database.yml'), aliases: true)
  ActiveRecord::Base.establish_connection(db_config[ENV['RACK_ENV'] || 'development'])
end

namespace :db do
  desc "Migrate the database"
  task :migrate => :environment do
    ActiveRecord::MigrationContext.new(ActiveRecord::Migrator.migrations_paths).migrate
  end

  desc "Create the database"
  task :create => :environment do
    ActiveRecord::Tasks::DatabaseTasks.create_current
  end
end
