-- ====================================================================
-- Bookie House - E-Book Store Database Setup
-- File: database/setup_all_tables.sql
-- Description: Complete Unified DDL Schema + Seed Data for Supabase PostgreSQL
-- Features: 3NF Relational Structure, Foreign Keys, RLS Configuration,
--           Realtime Publication, and Download Links for Confirmed Orders.
-- ====================================================================

-- --------------------------------------------------------------------
-- 1. DROP EXISTING TABLES (Reverse Dependency Order)
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS download_links CASCADE;
DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS ebooks CASCADE;
DROP TABLE IF EXISTS authors CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS roles CASCADE;

-- --------------------------------------------------------------------
-- 2. CREATE SCHEMA TABLES (DDL)
-- --------------------------------------------------------------------

-- 2.1 ตารางบทบาทผู้ใช้ (roles)
CREATE TABLE roles (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE
);

-- 2.2 ตารางผู้ใช้งาน (users)
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    role_id INT NOT NULL DEFAULT 2,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_users_role FOREIGN KEY (role_id) REFERENCES roles(role_id) ON DELETE RESTRICT
);

-- 2.3 ตารางหมวดหมู่หนังสือ (categories)
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

-- 2.4 ตารางนักเขียน / ผู้แต่ง (authors)
CREATE TABLE authors (
    author_id SERIAL PRIMARY KEY,
    author_name VARCHAR(100) NOT NULL,
    bio TEXT
);

-- 2.5 ตารางข้อมูล E-Book (ebooks)
CREATE TABLE ebooks (
    ebook_id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author_id INT NOT NULL,
    category_id INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    description TEXT,
    cover_image_url VARCHAR(255),
    file_download_url VARCHAR(255) DEFAULT 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_ebook_price CHECK (price >= 0.00),
    CONSTRAINT fk_ebooks_author FOREIGN KEY (author_id) REFERENCES authors(author_id) ON DELETE RESTRICT,
    CONSTRAINT fk_ebooks_category FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE RESTRICT
);

-- 2.6 ตารางคำสั่งซื้อ (orders)
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    order_status VARCHAR(20) NOT NULL DEFAULT 'pending',
    order_datetime TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_order_total CHECK (total_amount >= 0.00),
    CONSTRAINT chk_order_status CHECK (order_status IN ('pending', 'confirmed', 'cancelled')),
    CONSTRAINT fk_orders_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE RESTRICT
);

-- 2.7 ตารางรายละเอียดรายการในคำสั่งซื้อ (order_items)
CREATE TABLE order_items (
    item_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    ebook_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    price_per_unit DECIMAL(10, 2) NOT NULL,
    CONSTRAINT chk_order_quantity CHECK (quantity > 0),
    CONSTRAINT chk_price_per_unit CHECK (price_per_unit >= 0.00),
    CONSTRAINT fk_order_items_order FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    CONSTRAINT fk_order_items_ebook FOREIGN KEY (ebook_id) REFERENCES ebooks(ebook_id) ON DELETE RESTRICT
);

-- 2.8 ตารางการชำระเงิน (payments)
CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL UNIQUE,
    payment_method VARCHAR(50) NOT NULL,
    slip_image_url VARCHAR(255),
    is_verified BOOLEAN NOT NULL DEFAULT FALSE,
    payment_datetime TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_payments_order FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);

-- 2.9 ตารางสิทธิ์และลิงก์ดาวน์โหลด E-Book (download_links)
CREATE TABLE download_links (
    link_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    ebook_id INT NOT NULL,
    user_id INT NOT NULL,
    download_url TEXT NOT NULL,
    download_token VARCHAR(100) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_download_links_order FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    CONSTRAINT fk_download_links_ebook FOREIGN KEY (ebook_id) REFERENCES ebooks(ebook_id) ON DELETE RESTRICT,
    CONSTRAINT fk_download_links_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- --------------------------------------------------------------------
-- 3. SUPABASE ACCESS PERMISSIONS & REALTIME
-- --------------------------------------------------------------------

-- ปิด RLS เพื่อให้ Anonymous Key เข้าถึงอ่าน/เขียนข้อมูลในเว็บแอปได้สมบูรณ์
ALTER TABLE roles DISABLE ROW LEVEL SECURITY;
ALTER TABLE users DISABLE ROW LEVEL SECURITY;
ALTER TABLE categories DISABLE ROW LEVEL SECURITY;
ALTER TABLE authors DISABLE ROW LEVEL SECURITY;
ALTER TABLE ebooks DISABLE ROW LEVEL SECURITY;
ALTER TABLE orders DISABLE ROW LEVEL SECURITY;
ALTER TABLE order_items DISABLE ROW LEVEL SECURITY;
ALTER TABLE payments DISABLE ROW LEVEL SECURITY;
ALTER TABLE download_links DISABLE ROW LEVEL SECURITY;

GRANT ALL ON ALL TABLES IN SCHEMA public TO anon, authenticated, service_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO anon, authenticated, service_role;

-- เปิดการส่งข้อมูล Realtime ให้ Supabase Client
DO $$
BEGIN
    BEGIN
        ALTER PUBLICATION supabase_realtime ADD TABLE orders, order_items, payments, ebooks, categories, users, download_links;
    EXCEPTION WHEN duplicate_object THEN
        -- มีตารางอยู่ใน publication อยู่แล้ว
        NULL;
    END;
END $$;

-- --------------------------------------------------------------------
-- 4. INSERT SEED DATA
-- --------------------------------------------------------------------

-- 4.1 บทบาท (roles): 1 = admin, 2 = customer
INSERT INTO roles (role_id, role_name) VALUES
(1, 'admin'),
(2, 'customer');

-- 4.2 ผู้ใช้งาน (users)
INSERT INTO users (user_id, role_id, username, email, password_hash, full_name) VALUES
(1, 1, 'admin_bookie', 'admin@bookiehouse.com', 'password123', 'ผู้ดูแลระบบ Bookie House'),
(2, 2, 'somchai_s', 'somchai@gmail.com', 'password123', 'สมชาย สายอ่าน'),
(3, 2, 'wanida_k', 'wanida@hotmail.com', 'password123', 'วนิดา แก้วมณี'),
(4, 2, 'thanaporn_t', 'thanaporn@gmail.com', 'password123', 'ธนพร ทรัพย์มั่นคง'),
(5, 2, 'kris_dev', 'kris@techmail.com', 'password123', 'กฤษณะ พัฒนาการ'),
(6, 2, 'napat_m', 'napat@yahoo.com', 'password123', 'ณภัทร มีสุข'),
(7, 2, 'arisa_read', 'arisa@outlook.com', 'password123', 'อริสา รักการอ่าน'),
(8, 2, 'piti_b', 'piti@gmail.com', 'password123', 'ปิติ บุญส่ง'),
(9, 2, 'pim_chanok', 'pim@gmail.com', 'password123', 'พิมพ์ชนก นครศรี'),
(10, 2, 'chakrit_c', 'chakrit@gmail.com', 'password123', 'ชาคริต ชัยชนะ');

-- 4.3 หมวดหมู่หนังสือ (categories)
INSERT INTO categories (category_id, category_name, description) VALUES
(1, 'เทคโนโลยีและการเขียนโค้ด', 'หนังสือการพัฒนาเว็บ, ฐานข้อมูล และเทคโนโลยีสารสนเทศ'),
(2, 'ธุรกิจและการเงิน', 'กลยุทธ์ธุรกิจ การลงทุน และการบริหารจัดการองค์กร'),
(3, 'พัฒนาตนเองและจิตวิทยา', 'แนวคิดการใช้ชีวิต สร้างนิสัย และการทำงานร่วมกับผู้อื่น'),
(4, 'นิยายและวรรณกรรม', 'นิยายแฟนตาซี วรรณกรรมแปล และเรื่องสั้นร่วมสมัย');

-- 4.4 นักเขียน (authors)
INSERT INTO authors (author_id, author_name, bio) VALUES
(1, 'ดร. อนุชา พาเขียนโค้ด', 'ผู้เชี่ยวชาญด้าน Software Architecture และระบบฐานข้อมูล'),
(2, 'กุลดา จิตวิญญาณ', 'นักเขียนเบสต์เซลเลอร์ด้านการพัฒนาตนเองและจิตวิทยาบำบัด'),
(3, 'วิศรุต การเงินดี', 'ที่ปรึกษาการลงทุนและผู้แต่งหนังสือการเงินบุคคล'),
(4, 'นลินทิพย์ นิยายฝัน', 'นักเขียนนิยายวรรณกรรมแปลและจินตนิยายชื่อดัง');

-- 4.5 ข้อมูล E-Book (ebooks)
INSERT INTO ebooks (ebook_id, title, author_id, category_id, price, description, cover_image_url, file_download_url, is_active) VALUES
(1, 'Mastering SQL & Database Design', 1, 1, 350.00, 'คู่มือออกแบบฐานข้อมูลเชิงสัมพันธ์ตั้งแต่ 1NF ถึง 3NF การเขียน Index และการ Tuning SQL Query', 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&w=400&q=80', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', true),
(2, 'Modern Web Development with React', 1, 1, 420.00, 'ก้าวทันเทคโนโลยีเว็บยุคใหม่ด้วย React, Tailwind CSS และการเชื่อมต่อ RESTful APIs', 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?auto=format&fit=crop&w=400&q=80', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', true),
(3, 'Python Data Analysis for Beginners', 1, 1, 380.00, 'เริ่มต้นวิเคราะห์ข้อมูลและสร้าง Data Visualization ด้วย Pandas และ Numpy', 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?auto=format&fit=crop&w=400&q=80', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', true),
(4, 'การเงินง่ายๆ สำหรับมนุษย์เงินเดือน', 3, 2, 250.00, 'แผนที่การเงินฉบับทำตามได้ทันที การจัดสรรเงินเดือน วางแผนภาษี และลงทุนกองทุนรวม', 'https://images.unsplash.com/photo-1553729459-efe14ef6055d?auto=format&fit=crop&w=400&q=80', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', true),
(5, 'Startup Blueprint: จาก 0 สู่ 100 ล้าน', 3, 2, 320.00, 'กลยุทธ์สร้างธุรกิจสตาร์ทอัพให้เติบโตแบบก้าวกระโดด', 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?auto=format&fit=crop&w=400&q=80', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', true),
(6, 'Digital Marketing Strategy 2026', 3, 2, 290.00, 'เจาะลึกการทำการตลาดยุค AI และสร้าง Personal Branding ให้ติดตลาด', 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?auto=format&fit=crop&w=400&q=80', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', true),
(7, 'Atomic Habits: พลังแห่งนิสัยเล็กๆ', 2, 3, 280.00, 'เปลี่ยนชีวิตให้สำเร็จได้ด้วยการปรับพฤติกรรมเพียงวันละ 1%', 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?auto=format&fit=crop&w=400&q=80', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', true),
(8, 'The Art of Deep Work: ทำงานให้สำเร็จ', 2, 3, 270.00, 'ศิลปะการจดจ่อในโลกที่เต็มไปด้วยสิ่งรบกวน วิธีสร้างสมาธิขั้นสูง', 'https://images.unsplash.com/photo-1499750310107-5fef28a66643?auto=format&fit=crop&w=400&q=80', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', true),
(9, 'จิตวิทยาการสื่อสารในที่ทำงาน', 2, 3, 260.00, 'เทคนิคการเจรจาต่อรอง การปฏิเสธอย่างสุภาพ และการสร้างความสัมพันธ์', 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&w=400&q=80', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', true),
(10, 'มังกรไร้เงา ภาค 1: กำเนิดแดนสนธยา', 4, 4, 220.00, 'การผจญภัยในดินแดนเวทมนตร์โบราณที่ถูกลืม', 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?auto=format&fit=crop&w=400&q=80', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', true),
(11, 'มังกรไร้เงา ภาค 2: ศึกบัลลังก์มนตรา', 4, 4, 240.00, 'สงครามแย่งชิงบัลลังก์มนตราปะทุขึ้น พันธมิตรกลายเป็นศัตรู', 'https://images.unsplash.com/photo-1514533450685-4493e01d1fdc?auto=format&fit=crop&w=400&q=80', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', true),
(12, 'คดีฆาตกรรมห้องสมุดลับโบราณ', 4, 4, 230.00, 'ปริศนาการตายของบรรณารักษ์ชราในห้องหนังสือต้องห้าม', 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?auto=format&fit=crop&w=400&q=80', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', true);

-- 4.6 คำสั่งซื้อ 32 ออเดอร์ (orders)
INSERT INTO orders (order_id, user_id, total_amount, order_status, order_datetime) VALUES
(1,  2, 350.00, 'confirmed', '2026-08-01 10:15:00+07'),
(2,  3, 670.00, 'confirmed', '2026-08-02 11:20:00+07'),
(3,  4, 250.00, 'confirmed', '2026-08-03 14:05:00+07'),
(4,  5, 800.00, 'confirmed', '2026-08-04 09:30:00+07'),
(5,  6, 280.00, 'confirmed', '2026-08-05 16:45:00+07'),
(6,  7, 460.00, 'confirmed', '2026-08-06 13:10:00+07'),
(7,  8, 380.00, 'confirmed', '2026-08-07 15:25:00+07'),
(8,  9, 320.00, 'confirmed', '2026-08-08 18:40:00+07'),
(9,  10, 230.00, 'confirmed', '2026-08-09 12:00:00+07'),
(10, 2, 700.00, 'confirmed', '2026-08-10 17:15:00+07'),
(11, 3, 290.00, 'confirmed', '2026-08-11 10:50:00+07'),
(12, 4, 530.00, 'confirmed', '2026-08-12 11:35:00+07'),
(13, 5, 350.00, 'confirmed', '2026-08-13 14:20:00+07'),
(14, 6, 550.00, 'confirmed', '2026-08-14 16:00:00+07'),
(15, 7, 240.00, 'confirmed', '2026-08-15 19:30:00+07'),
(16, 8, 420.00, 'confirmed', '2026-08-16 08:45:00+07'),
(17, 9, 250.00, 'confirmed', '2026-08-17 13:15:00+07'),
(18, 10, 280.00, 'confirmed', '2026-08-18 20:10:00+07'),
(19, 2, 260.00, 'confirmed', '2026-08-19 15:40:00+07'),
(20, 3, 350.00, 'confirmed', '2026-08-20 12:25:00+07'),
(21, 4, 380.00, 'confirmed', '2026-08-21 17:50:00+07'),
(22, 5, 220.00, 'confirmed', '2026-08-22 10:05:00+07'),
(23, 6, 320.00, 'confirmed', '2026-08-23 11:15:00+07'),
(24, 7, 270.00, 'confirmed', '2026-08-24 14:30:00+07'),
(25, 8, 250.00, 'confirmed', '2026-08-25 18:20:00+07'),
(26, 9, 770.00, 'confirmed', '2026-08-26 16:10:00+07'),
(27, 10, 460.00, 'confirmed', '2026-08-27 13:45:00+07'),
(28, 2, 420.00, 'confirmed', '2026-08-28 09:20:00+07'),
(29, 3, 350.00, 'pending',   '2026-08-29 11:00:00+07'),
(30, 4, 280.00, 'pending',   '2026-08-29 15:30:00+07'),
(31, 5, 380.00, 'cancelled', '2026-08-30 10:15:00+07'),
(32, 6, 250.00, 'cancelled', '2026-08-30 16:40:00+07');

-- 4.7 รายละเอียดสินค้าในคำสั่งซื้อ (order_items)
INSERT INTO order_items (item_id, order_id, ebook_id, quantity, price_per_unit) VALUES
(1,  1,  1,  1, 350.00),
(2,  2,  2,  1, 420.00),
(3,  2,  4,  1, 250.00),
(4,  3,  4,  1, 250.00),
(5,  4,  2,  1, 420.00),
(6,  4,  3,  1, 380.00),
(7,  5,  7,  1, 280.00),
(8,  6,  10, 1, 220.00),
(9,  6,  11, 1, 240.00),
(10, 7,  3,  1, 380.00),
(11, 8,  5,  1, 320.00),
(12, 9,  12, 1, 230.00),
(13, 10, 1,  2, 350.00),
(14, 11, 6,  1, 290.00),
(15, 12, 7,  1, 280.00),
(16, 12, 4,  1, 250.00),
(17, 13, 1,  1, 350.00),
(18, 14, 8,  1, 270.00),
(19, 14, 7,  1, 280.00),
(20, 15, 11, 1, 240.00),
(21, 16, 2,  1, 420.00),
(22, 17, 4,  1, 250.00),
(23, 18, 7,  1, 280.00),
(24, 19, 9,  1, 260.00),
(25, 20, 1,  1, 350.00),
(26, 21, 3,  1, 380.00),
(27, 22, 10, 1, 220.00),
(28, 23, 5,  1, 320.00),
(29, 24, 8,  1, 270.00),
(30, 25, 4,  1, 250.00),
(31, 26, 1,  1, 350.00),
(32, 26, 2,  1, 420.00),
(33, 27, 10, 1, 220.00),
(34, 27, 11, 1, 240.00),
(35, 28, 2,  1, 420.00),
(36, 29, 1,  1, 350.00),
(37, 30, 7,  1, 280.00),
(38, 31, 3,  1, 380.00),
(39, 32, 4,  1, 250.00);

-- 4.8 การชำระเงิน (payments)
INSERT INTO payments (payment_id, order_id, payment_method, slip_image_url, is_verified) VALUES
(1,  1,  'พร้อมเพย์ QR', 'https://picsum.photos/seed/slip1/400/600', true),
(2,  2,  'พร้อมเพย์ QR', 'https://picsum.photos/seed/slip2/400/600', true),
(3,  3,  'โอนผ่านธนาคาร',  'https://picsum.photos/seed/slip3/400/600', true),
(4,  4,  'พร้อมเพย์ QR', 'https://picsum.photos/seed/slip4/400/600', true),
(5,  5,  'โอนผ่านธนาคาร',  'https://picsum.photos/seed/slip5/400/600', true),
(6,  6,  'พร้อมเพย์ QR', 'https://picsum.photos/seed/slip6/400/600', true),
(7,  7,  'พร้อมเพย์ QR', 'https://picsum.photos/seed/slip7/400/600', true),
(8,  8,  'โอนผ่านธนาคาร',  'https://picsum.photos/seed/slip8/400/600', true),
(9,  9,  'พร้อมเพย์ QR', 'https://picsum.photos/seed/slip9/400/600', true),
(10, 10, 'พร้อมเพย์ QR', 'https://picsum.photos/seed/slip10/400/600', true),
(11, 11, 'โอนผ่านธนาคาร',  'https://picsum.photos/seed/slip11/400/600', true),
(12, 12, 'พร้อมเพย์ QR', 'https://picsum.photos/seed/slip12/400/600', true),
(13, 13, 'พร้อมเพย์ QR', 'https://picsum.photos/seed/slip13/400/600', true),
(14, 14, 'โอนผ่านธนาคาร',  'https://picsum.photos/seed/slip14/400/600', true),
(15, 15, 'พร้อมเพย์ QR', 'https://picsum.photos/seed/slip15/400/600', true),
(16, 16, 'โอนผ่านธนาคาร',  'https://picsum.photos/seed/slip16/400/600', true),
(17, 17, 'พร้อมเพย์ QR', 'https://picsum.photos/seed/slip17/400/600', true),
(18, 18, 'พร้อมเพย์ QR', 'https://picsum.photos/seed/slip18/400/600', true),
(19, 19, 'โอนผ่านธนาคาร',  'https://picsum.photos/seed/slip19/400/600', true),
(20, 20, 'พร้อมเพย์ QR', 'https://picsum.photos/seed/slip20/400/600', true),
(21, 21, 'พร้อมเพย์ QR', 'https://picsum.photos/seed/slip21/400/600', true),
(22, 22, 'โอนผ่านธนาคาร',  'https://picsum.photos/seed/slip22/400/600', true),
(23, 23, 'พร้อมเพย์ QR', 'https://picsum.photos/seed/slip23/400/600', true),
(24, 24, 'พร้อมเพย์ QR', 'https://picsum.photos/seed/slip24/400/600', true),
(25, 25, 'โอนผ่านธนาคาร',  'https://picsum.photos/seed/slip25/400/600', true),
(26, 26, 'พร้อมเพย์ QR', 'https://picsum.photos/seed/slip26/400/600', true),
(27, 27, 'พร้อมเพย์ QR', 'https://picsum.photos/seed/slip27/400/600', true),
(28, 28, 'โอนผ่านธนาคาร',  'https://picsum.photos/seed/slip28/400/600', true),
(29, 29, 'พร้อมเพย์ QR', 'https://picsum.photos/seed/slip29/400/600', false),
(30, 30, 'โอนผ่านธนาคาร',  'https://picsum.photos/seed/slip30/400/600', false),
(31, 31, 'พร้อมเพย์ QR', NULL, false),
(32, 32, 'โอนผ่านธนาคาร',  NULL, false);

-- 4.9 สิทธิ์และลิงก์ดาวน์โหลด (download_links) เฉพาะคำสั่งซื้อที่ยืนยันแล้ว (confirmed)
INSERT INTO download_links (link_id, order_id, ebook_id, user_id, download_url, download_token, is_active) VALUES
(1,  1,  1,  2,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_001_sql', true),
(2,  2,  2,  3,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_002_react', true),
(3,  2,  4,  3,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_003_fin', true),
(4,  3,  4,  4,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_004_fin', true),
(5,  4,  2,  5,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_005_react', true),
(6,  4,  3,  5,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_006_py', true),
(7,  5,  7,  6,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_007_habits', true),
(8,  6,  10, 7,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_008_dragon1', true),
(9,  6,  11, 7,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_009_dragon2', true),
(10, 7,  3,  8,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_010_py', true),
(11, 8,  5,  9,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_011_startup', true),
(12, 9,  12, 10, 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_012_mystery', true),
(13, 10, 1,  2,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_013_sql', true),
(14, 11, 6,  3,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_014_mkt', true),
(15, 12, 7,  4,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_015_habits', true),
(16, 12, 4,  4,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_016_fin', true),
(17, 13, 1,  5,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_017_sql', true),
(18, 14, 8,  6,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_018_deep', true),
(19, 14, 7,  6,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_019_habits', true),
(20, 15, 11, 7,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_020_dragon2', true),
(21, 16, 2,  8,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_021_react', true),
(22, 17, 4,  9,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_022_fin', true),
(23, 18, 7,  10, 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_023_habits', true),
(24, 19, 9,  2,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_024_comm', true),
(25, 20, 1,  3,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_025_sql', true),
(26, 21, 3,  4,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_026_py', true),
(27, 22, 10, 5,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_027_dragon1', true),
(28, 23, 5,  6,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_028_startup', true),
(29, 24, 8,  7,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_029_deep', true),
(30, 25, 4,  8,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_030_fin', true),
(31, 26, 1,  9,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_031_sql', true),
(32, 26, 2,  9,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_032_react', true),
(33, 27, 10, 10, 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_033_dragon1', true),
(34, 27, 11, 10, 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_034_dragon2', true),
(35, 28, 2,  2,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_035_react', true);

-- --------------------------------------------------------------------
-- 5. RE-SYNC PRIMARY KEY SEQUENCES
-- --------------------------------------------------------------------
SELECT setval('roles_role_id_seq', (SELECT COALESCE(MAX(role_id), 1) FROM roles));
SELECT setval('users_user_id_seq', (SELECT COALESCE(MAX(user_id), 1) FROM users));
SELECT setval('categories_category_id_seq', (SELECT COALESCE(MAX(category_id), 1) FROM categories));
SELECT setval('authors_author_id_seq', (SELECT COALESCE(MAX(author_id), 1) FROM authors));
SELECT setval('ebooks_ebook_id_seq', (SELECT COALESCE(MAX(ebook_id), 1) FROM ebooks));
SELECT setval('orders_order_id_seq', (SELECT COALESCE(MAX(order_id), 1) FROM orders));
SELECT setval('order_items_item_id_seq', (SELECT COALESCE(MAX(item_id), 1) FROM order_items));
SELECT setval('payments_payment_id_seq', (SELECT COALESCE(MAX(payment_id), 1) FROM payments));
SELECT setval('download_links_link_id_seq', (SELECT COALESCE(MAX(link_id), 1) FROM download_links));

-- ====================================================================
-- เสร็จสิ้นการสร้างตารางและนำเข้าข้อมูล Bookie House สำเร็จ 100%
-- ====================================================================
