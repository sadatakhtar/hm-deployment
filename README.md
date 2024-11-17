# 🍽️ Homemade - Database Structure

This document outlines the database schema for the Homemade Food Marketplace application. The app connects homemade food sellers (cakes, samosas, etc.) with customers, allowing users to browse products, place orders, and make payments. The backend is built with Spring Boot, using a PostgreSQL database.

## 🗂️ Entity-Relationship Diagram (ERD) Overview

The main entities in this schema are:
- **User**: Represents both buyers and sellers.
- **Product**: Represents homemade food items listed by sellers.
- **Category**: Represents the classification of products (e.g., cakes, snacks).
- **Order**: Represents a customer's purchase order.
- **Order Items**: Represents individual items within an order.
- **Address**: Represents delivery addresses associated with users.
- **Review**: Stores feedback from customers on products.
- **Payment**: Stores user payment methods.
- **Transaction**: Tracks payment and refund transactions.

## 📑 Database Tables

### 1. **User Table**
Stores user information for both buyers and sellers.

| Column     | Type         | Constraints                                     |
|------------|--------------|-------------------------------------------------|
| user_id    | `SERIAL`     | PRIMARY KEY                                     |
| username   | `VARCHAR(100)` | NOT NULL                                      |
| email      | `VARCHAR(100)` | UNIQUE, NOT NULL                              |
| password   | `VARCHAR(255)` | NOT NULL                                      |
| role       | `VARCHAR(20)` | CHECK (role IN ('seller', 'buyer')), NOT NULL  |
| created_at | `TIMESTAMP`  | DEFAULT CURRENT_TIMESTAMP                      |

### 2. **Category Table**
Stores product categories (e.g., cakes, snacks).

| Column      | Type         | Constraints      |
|-------------|--------------|------------------|
| category_id | `SERIAL`     | PRIMARY KEY      |
| name        | `VARCHAR(100)` | NOT NULL         |
| description | `TEXT`       |                  |

### 3. **Product Table**
Stores details of products listed by sellers.

| Column         | Type         | Constraints                                |
|----------------|--------------|--------------------------------------------|
| product_id     | `SERIAL`     | PRIMARY KEY                                |
| user_id        | `INTEGER`    | FOREIGN KEY REFERENCES `user` (user_id)    |
| category_id    | `INTEGER`    | FOREIGN KEY REFERENCES `category` (category_id) |
| name           | `VARCHAR(100)` | NOT NULL                                   |
| description    | `TEXT`       |                                            |
| price          | `DECIMAL(10, 2)` | NOT NULL                                 |
| stock_quantity | `INTEGER`    | DEFAULT 0                                  |
| created_at     | `TIMESTAMP`  | DEFAULT CURRENT_TIMESTAMP                  |

### 4. **Address Table**
Stores delivery addresses for users.

| Column      | Type         | Constraints                                |
|-------------|--------------|--------------------------------------------|
| address_id  | `SERIAL`     | PRIMARY KEY                                |
| user_id     | `INTEGER`    | FOREIGN KEY REFERENCES `user` (user_id)    |
| street      | `VARCHAR(255)` | NOT NULL                                   |
| city        | `VARCHAR(100)` | NOT NULL                                   |
| postal_code | `VARCHAR(20)` | NOT NULL                                   |
| country     | `VARCHAR(100)` | NOT NULL                                   |

### 5. **Order Table**
Stores order details placed by users.

| Column       | Type         | Constraints                                |
|--------------|--------------|--------------------------------------------|
| order_id     | `SERIAL`     | PRIMARY KEY                                |
| user_id      | `INTEGER`    | FOREIGN KEY REFERENCES `user` (user_id)    |
| address_id   | `INTEGER`    | FOREIGN KEY REFERENCES `address` (address_id)|
| payment_id   | `INTEGER`    | FOREIGN KEY REFERENCES `payment` (payment_id)|
| total_amount | `DECIMAL(10, 2)` | NOT NULL                                 |
| status       | `VARCHAR(20)` | DEFAULT 'Pending'                         |
| created_at   | `TIMESTAMP`  | DEFAULT CURRENT_TIMESTAMP                  |

### 6. **Order Items Table**
Stores individual items within an order.

| Column       | Type         | Constraints                                |
|--------------|--------------|--------------------------------------------|
| order_item_id | `SERIAL`    | PRIMARY KEY                                |
| order_id     | `INTEGER`    | FOREIGN KEY REFERENCES `order` (order_id)  |
| product_id   | `INTEGER`    | FOREIGN KEY REFERENCES `product` (product_id)|
| quantity     | `INTEGER`    | NOT NULL                                   |
| price        | `DECIMAL(10, 2)` | NOT NULL                                 |

### 7. **Review Table**
Stores customer feedback on products.

| Column    | Type         | Constraints                                |
|-----------|--------------|--------------------------------------------|
| review_id | `SERIAL`     | PRIMARY KEY                                |
| user_id   | `INTEGER`    | FOREIGN KEY REFERENCES `user` (user_id)    |
| product_id| `INTEGER`    | FOREIGN KEY REFERENCES `product` (product_id)|
| rating    | `INTEGER`    | CHECK (rating >= 1 AND rating <= 5)        |
| comment   | `TEXT`       |                                            |
| created_at| `TIMESTAMP`  | DEFAULT CURRENT_TIMESTAMP                  |

### 8. **Payment Table**
Stores user payment methods.

| Column          | Type         | Constraints                                |
|-----------------|--------------|--------------------------------------------|
| payment_id      | `SERIAL`     | PRIMARY KEY                                |
| user_id         | `INTEGER`    | FOREIGN KEY REFERENCES `user` (user_id)    |
| payment_method  | `VARCHAR(50)`| CHECK (payment_method IN ('credit_card', 'paypal', 'bank_transfer')) |
| provider        | `VARCHAR(100)` |                                          |
| account_number  | `VARCHAR(100)` |                                          |
| expiry_date     | `DATE`       |                                            |
| created_at      | `TIMESTAMP`  | DEFAULT CURRENT_TIMESTAMP                  |

### 9. **Transaction Table**
Tracks payment and refund transactions.

| Column            | Type         | Constraints                                |
|-------------------|--------------|--------------------------------------------|
| transaction_id    | `SERIAL`     | PRIMARY KEY                                |
| order_id          | `INTEGER`    | FOREIGN KEY REFERENCES `order` (order_id)  |
| payment_id        | `INTEGER`    | FOREIGN KEY REFERENCES `payment` (payment_id)|
| transaction_date  | `TIMESTAMP`  | DEFAULT CURRENT_TIMESTAMP                  |
| amount            | `DECIMAL(10, 2)` | NOT NULL                                 |
| currency          | `VARCHAR(10)` | DEFAULT 'USD'                              |
| status            | `VARCHAR(20)` | CHECK (status IN ('Pending', 'Completed', 'Failed', 'Refunded')) |
| transaction_type  | `VARCHAR(20)` | CHECK (transaction_type IN ('Payment', 'Refund')) |
| payment_reference | `VARCHAR(255)` |                                          |

## 🔒 Security Considerations
- **Sensitive Data**: Do not store raw payment details (e.g., CVV codes). Use a third-party payment gateway for secure handling.
- **User Authentication**: Use strong hashing (e.g., bcrypt) for storing passwords.
- **Data Validation**: Ensure data validation at the application layer to prevent SQL injection and other attacks.

## 🔗 Table Relationships Overview
- **User** ↔ **Product**: One-to-Many (One user can list multiple products).
- **User** ↔ **Order**: One-to-Many (One user can place multiple orders).
- **Order** ↔ **Order Items**: One-to-Many (One order can have multiple items).
- **Product** ↔ **Review**: One-to-Many (One product can have multiple reviews).
- **User** ↔ **Payment**: One-to-Many (One user can have multiple payment methods).
- **Order** ↔ **Payment**: One-to-One (One order is associated with one payment).
- **Payment** ↔ **Transaction**: One-to-Many (One payment can have multiple transactions).

## 📝 Database Initialization Script
For detailed SQL commands to create these tables, refer to the `db-init.sql` script in the repository.


### Launch Instructions

Make sure the paths in the script files match your local setup

## Steps
1. to start the FE, BE and DB run: ./clearAndRun
   - localhost:8080 --> postgreSQL DB
   - localhost:3000 --> Frontend
   - localhost:8081 --> Spring Boot API

2. To stop the scripts, run: ./stop.sh
