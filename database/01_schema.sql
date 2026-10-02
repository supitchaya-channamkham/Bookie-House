-- ========================================================
-- Mini Project: Bookie House - E-Book Store Database
-- File: 01_schema.sql
-- Description: DDL Schema creation with 3NF and Constraints
-- ========================================================

-- สร้างฐานข้อมูลและเลือกใช้งาน (MySQL / MariaDB Compatible)
CREATE DATABASE IF NOT EXISTS bookie_house_db
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE bookie_house_db;

-- --------------------------------------------------------
-- 1. ตารางบทบาทผู้ใช้ (roles)
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE
);

-- --------------------------------------------------------
-- 2. ตารางผู้ใช้งาน (users)
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    role_id INT NOT NULL DEFAULT 2,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_users_role FOREIGN KEY (role_id) REFERENCES roles(role_id) ON DELETE RESTRICT
);

-- --------------------------------------------------------
-- 3. ตารางหมวดหมู่หนังสือ (categories)
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

-- --------------------------------------------------------
-- 4. ตารางนักเขียน / ผู้แต่ง (authors)
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    author_name VARCHAR(100) NOT NULL,
    bio TEXT
);

-- --------------------------------------------------------
-- 5. ตารางข้อมูล E-Book (ebooks)
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS ebooks (
    ebook_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author_id INT NOT NULL,
    category_id INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    description TEXT,
    cover_image_url VARCHAR(255),
    file_download_url VARCHAR(255) DEFAULT 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_ebook_price CHECK (price >= 0.00),
    CONSTRAINT fk_ebooks_author FOREIGN KEY (author_id) REFERENCES authors(author_id) ON DELETE RESTRICT,
    CONSTRAINT fk_ebooks_category FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE RESTRICT
);

-- --------------------------------------------------------
-- 6. ตารางคำสั่งซื้อ (orders)
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    order_status ENUM('pending', 'confirmed', 'cancelled') NOT NULL DEFAULT 'pending',
    order_datetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_order_total CHECK (total_amount >= 0.00),
    CONSTRAINT fk_orders_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE RESTRICT
);

-- --------------------------------------------------------
-- 7. ตารางรายละเอียดรายการในคำสั่งซื้อ (order_items)
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS order_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    ebook_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    price_per_unit DECIMAL(10, 2) NOT NULL,
    CONSTRAINT chk_order_quantity CHECK (quantity > 0),
    CONSTRAINT chk_price_per_unit CHECK (price_per_unit >= 0.00),
    CONSTRAINT fk_order_items_order FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    CONSTRAINT fk_order_items_ebook FOREIGN KEY (ebook_id) REFERENCES ebooks(ebook_id) ON DELETE RESTRICT
);

-- --------------------------------------------------------
-- 8. ตารางการชำระเงิน (payments)
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL UNIQUE,
    payment_method VARCHAR(50) NOT NULL,
    slip_image_url VARCHAR(255),
    is_verified BOOLEAN NOT NULL DEFAULT FALSE,
    payment_datetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_payments_order FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);

-- --------------------------------------------------------
-- 9. ตารางสิทธิ์และลิงก์ดาวน์โหลด E-Book (download_links)
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS download_links (
    link_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    ebook_id INT NOT NULL,
    user_id INT NOT NULL,
    download_url TEXT NOT NULL,
    download_token VARCHAR(100) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_download_links_order FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    CONSTRAINT fk_download_links_ebook FOREIGN KEY (ebook_id) REFERENCES ebooks(ebook_id) ON DELETE RESTRICT,
    CONSTRAINT fk_download_links_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);