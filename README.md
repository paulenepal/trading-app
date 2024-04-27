# Rails API for Trails.io Stock Trading App

This README provides guidance on setting up, configuring, and making API requests for the Trails.io Stock Trading App. It includes detailed examples of API requests and corresponding responses to facilitate seamless integration with the app.

## Table of Contents

1. [Introduction](#introduction)
    - [Prerequisites](#prerequisites)
    - [User Stories](#user-stories)

2. [Getting Started](#getting-started)
    - [Dependencies](#dependencies)
    - [Configuration](#configuration)

3. [Making API Requests](#api-requests)
    - Endpoint
    - Response Form
    - Request Parameters
    - Request Headers

## Introduction

### Prerequisites
1. Basic understanding of HTTP Requests

### User Stories 
#### Admin User Stories
- User Story #1: As an Admin, I want to create a new trader to manually add them to the app 
- User Story #2: As an Admin, I want to edit a specific trader to update his/her details 
- User Story #3: As an Admin, I want to view a specific trader to show his/her details 
- User Story #4: As an Admin, I want to see all the trader that registered in the app so I can track all the traders 
- User Story #5: As an Admin, I want to have a page for pending trader sign up to easily check if there's a new trader sign up 
- User Story #6: As an Admin, I want to approve a trader sign up so that he/she can start adding stocks 
- User Story #7: As an Admin, I want to see all the transactions so that I can monitor the transaction flow of the app 

#### Trader User Stories
- User Story #1: As a Trader, I want to create an account to buy and sell stocks 
- User Story #2: As a Trader, I want to log in my credentials so that I can access my account on the app 
- User Story #3: As a Trader, I want to receive an email to confirm my pending Account signup 
- User Story #4: As a Trader, I want to receive an approval Trader Account email to notify me once my account has been approved 
- User Story #5: As a Trader, I want to buy a stock to add to my investment(Trader signup should be approved) 
- User Story #6: As a Trader, I want to have a My Portfolio page to see all my stocks 
- User Story #7: As a Trader, I want to have a Transaction page to see and monitor all the transactions made by buying and 
selling stocks 
- User Story #8: As a Trader, I want to sell my stocks to gain money.

## Getting Started

### Dependencies
- Run `bundle install` to install dependencies.

#### Ruby Version
- This application was built using Ruby 3.3. 

#### Ruby Gems
- [Devise](https://github.com/heartcombo/devise)
- [Devise-JWT](https://github.com/waiting-for-dev/devise-jwt)
- [JSONAPI-Serializer](https://github.com/jsonapi-serializer/jsonapi-serializer)
- [IEX Ruby Client](https://github.com/dblock/iex-ruby-client)
- [Rack CORS](https://github.com/cyu/rack-cors)
- [PostgreSQL](https://www.postgresql.org/docs/)

#### Database
- PostgreSQL 16.1.

### Configuration

#### Database Creation

1. Run the command to create the database: `rails db:create`

#### Database Initialization

1. Run the migrations to setup the database schema: `rails db:migrate`

## API Requests

### User Registration
#### Endpoint
```
HTTP Method: POST
URL: http://localhost:3001/signup
```

#### Sample Request Body
```json
{
    "user": {
        "email": "user@gmail.com",
        "password": "pass_1234567",
        "first_name": "John",
        "middle_name": "Test",
        "last_name": "Doe",
        "username": "doejohn01",
        "birthday": "April 20, 2000",
    }
}
```

#### Parameters

| Parameter | Desctription | Required |
|-----------|--------------|----------|
| email     | Email  | true  |
| password  | Password  | true  |
| first_name  | First Name  | true  |
| middle_name  | Middle Name  | false  |
| last_name  | Last Name  | true  |
| username  | Username  | true  |
| birthday  | Birthdate  | true  |

---
### User Login
#### Endpoint
```
HTTP Method: POST
URL: http://localhost:3001/signin
```

#### Sample Request Body
```json
{
    "user": {
        "email": "user@gmail.com",
        "password": "pass_1234567"
    }
}
```

#### Parameters

| Parameter | Desctription | Required |
|-----------|--------------|----------|
| email     | Email  | true  |
| password  | Password  | true  |

---
### User Details
#### Endpoint
```
HTTP Method: GET
URL: http://localhost:3001/user/:id
```

#### Request Headers
| Key | Value | Required |
|-----------|--------------|----------|
| Authorization     | Bearer Token  | true  |

---
### Get All Stock Quotes
#### Endpoint
```
HTTP Method: GET
URL: http://localhost:3001/watchlist
```

#### Request Headers
| Key | Value | Required |
|-----------|--------------|----------|
| Authorization     | Bearer Token  | true  |

---
### Show Symbol Details
#### Endpoint
```
HTTP Method: GET
URL: http://localhost:3001/watchlist/:symbol
```

#### Request Headers
| Key | Value | Required |
|-----------|--------------|----------|
| Authorization     | Bearer Token  | true  |

---
### User Stock Transactions
#### Endpoint
```
HTTP Method: GET
URL: http://localhost:3001/transactions
```

#### Request Headers
| Key | Value | Required |
|-----------|--------------|----------|
| Authorization     | Bearer Token  | true  |

---
### View Single Stock Transaction
#### Endpoint
```
HTTP Method: GET
URL: http://localhost:3001/transactions/:id
```

#### Request Headers
| Key | Value | Required |
|-----------|--------------|----------|
| Authorization     | Bearer Token  | true  |

---
### Buy Stocks
```
HTTP Method: POST
URL: http://localhost:3001/transactions/buy
```

#### Sample Request Body
```json
{
  "transaction": {
    "symbol": "AMZN",
    "quantity": 1,
    "transaction_type": 0
  }
}
```

#### Parameters

| Parameter | Desctription | Required |
|-----------|--------------|----------|
| symbol    | Ticker Symbol  | true  |
| quantity  | Stock Quantity  | true  |
| transaction_type | 0 - for buy  | true  |

#### Request Headers
| Key | Value | Required |
|-----------|--------------|----------|
| Authorization     | Bearer Token  | true  |

---
### Sell Stocks
```
HTTP Method: POST
URL: http://localhost:3001/transactions/sell
```

#### Sample Request Body
```json
{
  "transaction": {
    "symbol": "AMZN",
    "quantity": 1,
    "transaction_type": 1
  }
}
```

#### Parameters

| Parameter | Desctription | Required |
|-----------|--------------|----------|
| symbol    | Ticker Symbol  | true  |
| quantity  | Stock Quantity  | true  |
| transaction_type | 1  | true  |

#### Request Headers
| Key | Value | Required |
|-----------|--------------|----------|
| Authorization     | Bearer Token  | true  |

---
### User Portfolio
#### Endpoint
```
HTTP Method: GET
URL: http://localhost:3001/stocks
```

#### Request Headers
| Key | Value | Required |
|-----------|--------------|----------|
| Authorization     | Bearer Token  | true  |

---
### View Single Stock Details from User Portfolio
#### Endpoint
```
HTTP Method: GET
URL: http://localhost:3001/stocks/:id
```

#### Request Headers
| Key | Value | Required |
|-----------|--------------|----------|
| Authorization     | Bearer Token  | true  |

### Search Stocks from User Portfolio
```
HTTP Method: POST
URL: http://localhost:3001/stocks/search
```

#### Sample Request Body
```json
{
    "symbol": "N"
}
```

#### Parameters

| Parameter | Desctription | Required |
|-----------|--------------|----------|
| symbol    | Any Letter  | true  |

#### Request Headers
| Key | Value | Required |
|-----------|--------------|----------|
| Authorization     | Bearer Token  | true  |
