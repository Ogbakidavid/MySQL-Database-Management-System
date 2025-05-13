# Library Management System - MySQL Database

![Database ER Diagram](ERD.png)

## 📖 Description
A complete MySQL database solution for library management systems. This database tracks books, members, loans, authors, and fines with proper relational structure and constraints.

## ✨ Features
- **Comprehensive table structure** for all library operations
- **Proper relationships** (1:1, 1:M, M:M) between entities
- **Constraints enforcement** (PK, FK, NOT NULL, UNIQUE)
- **Sample queries** included for common operations

## 🛠️ Technologies Used
- MySQL 8.0+
- Relational Database Design

## 🚀 Setup Instructions

### Prerequisites
- MySQL Server installed
- MySQL client/command line access

### Installation
1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/library-management-db.git
   cd library-management-db

2. Import the database:

bash
mysql -u [username] -p < library_management.sql
(Enter your MySQL password when prompted)

3. Connect to MySQL and verify:

bash
mysql -u [username] -p
USE library_db;
SHOW TABLES;