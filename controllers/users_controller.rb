require 'sinatra/base'
require 'json'

class UsersController < Sinatra::Base
  post '/register' do
    data = JSON.parse(request.body.read) rescue {}
    account_number = SecureRandom.hex(4)
    user = User.new(account_number: account_number, pin: data['pin'], balance: data['balance'] || 0.0)
    if user.save
      { message: 'Registered user', account_number: user.account_number }.to_json
    else
      halt 400, { error: user.errors.full_messages }.to_json
    end
  end

  post '/login' do
    data = JSON.parse(request.body.read) rescue {}
    user = User.find_by(account_number: data['account_number'])
    if user&.authenticate(data['pin'])
      { message: 'Login successful' }.to_json
    else
      halt 401, { error: 'Invalid credentials' }.to_json
    end
  end
end
