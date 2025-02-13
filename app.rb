require 'sinatra/activerecord'
require_relative './models/user'
require_relative './models/transaction'
require_relative './controllers/users_controller'
require_relative './controllers/transactions_controller'

# Defining the app as a modular class
class ATMApp < Sinatra::Base
  configure do
    # set :database, { adapter: 'sqlite3', database: 'db/atm.db' }
    set :database, YAML.safe_load(File.read('config/database.yml'), aliases: true)[ENV['RACK_ENV'] || 'development']
  end

  use UsersController
  use TransactionsController

  # Run the app
  run! if app_file == $0
end
