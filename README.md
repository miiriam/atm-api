# ATM REST API

### Overview

This is a RESTful API for an ATM system built using **Sinatra** and **Active Record** with **SQLite** as the database. It allows user to:

* Register an account
* Log in with a secire PIN
* Check their account balance 
* Deposit money
* Withdraw money
* Maintain a transaction money

---

### Prerequisites

Ensure you have the following installed:

* **Ruby** (version 2.7 or later recommended)
* **Bundler** (gem install bundler)
* **SQLite3**
* **Postman or cURL** (for testing)

---

### Setup Instructions
#### 1. Install Dependencies
`````
bundle install
`````

#### 2. Set Up Database
`````
bundle exec rake db:migrate
`````

If is neccesary, reset the datase
`````
rm -f db/atm.db
bundle exec rake db:migrate
`````

#### 3. Run the API

Start the Sinatra server:

`````
ruby app.rb
`````

By default, the server will run at `http://127.0.0.1:4567/`

---

### API Endpoints

#### User registration

`POST /register` - Register a new account
**Request:**

`````
{
  "pin": "1234",
  "balance": 1000.00
}
`````

**Response:**
`````
{
  "message": "Registered user",
  "account_number": "abcdef123456"
}
`````

---
#### User Login

`POST /login` - Authenticate user with account number and PIN.

**Request:**
`````
{
  "account_number": "abcdef123456",
  "pin": "1234"
}
`````

**Response:**
`````
{
  "message": "Login successful"
}
`````
---

#### Check Balance

`GET /balance` - Retrive current account balance.

**Headers:**
`````
Authorization: account_number:pin
`````

**Response**
`````
{
  "balance": 1000.00
}
`````
---

#### Deposit Money
`POST /deposit` - Deposit founds into the account.

**Headers:**
`````
Authorization: account_number:pin
`````

**Request**
`````
{
  "amount": 500.00
}
`````

**Response**
`````
{
  "message": "Deposit successful",
  "balance": 1500.00
}
`````

---

#### Withdraw Money
`POST /withdraw` - Withdraw founds from the account (handles concurrency).

**Headers:**
`````
Authorization: account_number:pin
`````

**Request**
`````
{
  "amount": 200.00
}
`````

**Response**
`````
{
  "message": "Successful withdrawal",
  "balance": 1300.00
}
`````
---

### Running test

To test the API using cURL, run the following commands:

#### Register a new user
````
curl -X POST http://127.0.0.1:4567/register \
     -H "Content-Type: application/json" \
     -d '{"pin": "1234", "balance": 1000.0}'
````

#### Check balance
````
curl -X GET http://127.0.0.1:4567/balance \
     -H "Authorization: abcdef123456:1234"
````

#### Deposit funds
````
curl -X POST http://127.0.0.1:4567/deposit \
     -H "Authorization: abcdef123456:1234" \
     -H "Content-Type: application/json" \
     -d '{"amount": 500}'
````

#### Withdraw funds
````
curl -X POST http://127.0.0.1:4567/withdraw \
     -H "Authorization: abcdef123456:1234" \
     -H "Content-Type: application/json" \
     -d '{"amount": 200}'
````
