-- Library Management System Database
-- Created by [David Ogbaki]
-- Date: [5/13/2025]

-- Create database
DROP DATABASE IF EXISTS library_management;
CREATE DATABASE library_management;
USE library_management;

-- Members table (1-M with Loans)
CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address VARCHAR(200),
    membership_date DATE NOT NULL,
    membership_status ENUM('Active', 'Expired', 'Suspended') DEFAULT 'Active',
    CONSTRAINT chk_email CHECK (email LIKE '%@%.%')
);

-- Authors table (M-M with Books through book_authors)
CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    birth_date DATE,
    nationality VARCHAR(50),
    biography TEXT
);

-- Publishers table (1-M with Books)
CREATE TABLE publishers (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(200),
    phone VARCHAR(20),
    email VARCHAR(100),
    website VARCHAR(100)
);

-- Books table (M-M with Authors, 1-M with Publishers, 1-M with BookCopies)
CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    title VARCHAR(200) NOT NULL,
    publication_year INT,
    genre VARCHAR(50),
    edition INT,
    publisher_id INT,
    pages INT,
    description TEXT,
    language VARCHAR(30) DEFAULT 'English',
    FOREIGN KEY (publisher_id) REFERENCES publishers(publisher_id) ON DELETE SET NULL
);

-- Book-Authors junction table (M-M relationship)
CREATE TABLE book_authors (
    book_id INT NOT NULL,
    author_id INT NOT NULL,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES authors(author_id) ON DELETE CASCADE
);

-- BookCopies table (1-M with Loans)
CREATE TABLE book_copies (
    copy_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    acquisition_date DATE NOT NULL,
    status ENUM('Available', 'Loaned', 'Lost', 'Damaged', 'In Repair') DEFAULT 'Available',
    shelf_location VARCHAR(20),
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE
);

-- Loans table (M-1 with Members, M-1 with BookCopies)
CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    copy_id INT NOT NULL,
    member_id INT NOT NULL,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    fine_amount DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (copy_id) REFERENCES book_copies(copy_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    CONSTRAINT chk_dates CHECK (due_date >= loan_date AND (return_date IS NULL OR return_date >= loan_date))
);

-- Fines table (1-1 with Loans)
CREATE TABLE fines (
    fine_id INT AUTO_INCREMENT PRIMARY KEY,
    loan_id INT UNIQUE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    issue_date DATE NOT NULL,
    payment_date DATE,
    status ENUM('Pending', 'Paid', 'Waived') DEFAULT 'Pending',
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id) ON DELETE CASCADE
);

-- Reservations table (M-1 with Members, M-1 with Books)
CREATE TABLE reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    reservation_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Pending', 'Fulfilled', 'Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE
);

-- Staff table
CREATE TABLE staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    position VARCHAR(50) NOT NULL,
    hire_date DATE NOT NULL,
    salary DECIMAL(10,2),
    CONSTRAINT chk_staff_email CHECK (email LIKE '%@%.%')
);

-- Create indexes for performance
CREATE INDEX idx_books_title ON books(title);
CREATE INDEX idx_books_isbn ON books(isbn);
CREATE INDEX idx_members_email ON members(email);
CREATE INDEX idx_loans_member ON loans(member_id);
CREATE INDEX idx_loans_dates ON loans(loan_date, due_date);