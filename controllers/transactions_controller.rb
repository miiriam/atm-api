require 'sinatra/base'
require 'json'

class TransactionsController < Sinatra::Base
  before do
    content_type :json
    if request.path_info != '/login' && request.path_info != '/register'
      auth_header = request.env['HTTP_AUTHORIZATION']
      halt 401, { error: 'Authentication missing' }.to_json unless auth_header

      account_number, pin = auth_header.split(':')
      @current_user = User.find_by(account_number: account_number)
      halt 401, { error: 'Authentication failed' }.to_json unless @current_user&.authenticate(pin)
    end
  end

  get '/balance' do
    { balance: @current_user.balance }.to_json
  end

  post '/deposit' do
    data = JSON.parse(request.body.read) rescue {}
    amount = data['amount'].to_f
    halt 400, { error: 'Invalid amount' }.to_json if amount <= 0

    @current_user.transaction do
      @current_user.lock!
      @current_user.update!(balance: @current_user.balance + amount)
      Transaction.create!(user: @current_user, amount: amount, transaction_type: 'deposit')
    end
    { message: 'Deposit successful', balance: @current_user.balance }.to_json
  end

  post '/withdraw' do
    data = JSON.parse(request.body.read) rescue {}
    amount = data['amount'].to_f
    halt 400, { error: 'Invalid amount' }.to_json if amount <= 0

    @current_user.transaction do
      @current_user.lock!
      if @current_user.balance >= amount
        @current_user.update!(balance: @current_user.balance - amount)
        Transaction.create!(user: @current_user, amount: amount, transaction_type: 'withdraw')
        { message: 'Successful withdrawal', balance: @current_user.balance }.to_json
      else
        halt 400, { error: 'Insufficient funds' }.to_json
      end
    end
  end
end
