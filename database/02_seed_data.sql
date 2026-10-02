-- ========================================================
-- Mini Project: Bookie House - E-Book Store Database
-- File: 02_seed_data.sql
-- Description: Realistic Seed Data (32 Orders, Users, Books, Download Links)
-- ========================================================

USE bookie_house_db;

-- 1. เพิ่มข้อมูลบทบาท (roles): 1 = admin, 2 = customer
INSERT INTO roles (role_id, role_name) VALUES
(1, 'admin'),
(2, 'customer');

-- 2. เพิ่มข้อมูลผู้ใช้งาน (users)
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

-- 3. เพิ่มข้อมูลหมวดหมู่ (categories)
INSERT INTO categories (category_id, category_name, description) VALUES
(1, 'เทคโนโลยีและการเขียนโค้ด', 'หนังสือการพัฒนาเว็บ, ฐานข้อมูล และเทคโนโลยีสารสนเทศ'),
(2, 'ธุรกิจและการเงิน', 'กลยุทธ์ธุรกิจ การลงทุน และการบริหารจัดการองค์กร'),
(3, 'พัฒนาตนเองและจิตวิทยา', 'แนวคิดการใช้ชีวิต สร้างนิสัย และการทำงานร่วมกับผู้อื่น'),
(4, 'นิยายและวรรณกรรม', 'นิยายแฟนตาซี วรรณกรรมแปล และเรื่องสั้นร่วมสมัย');

-- 4. เพิ่มข้อมูลนักเขียน (authors)
INSERT INTO authors (author_id, author_name, bio) VALUES
(1, 'ดร. อนุชา พาเขียนโค้ด', 'ผู้เชี่ยวชาญด้าน Software Architecture และระบบฐานข้อมูล'),
(2, 'กุลดา จิตวิญญาณ', 'นักเขียนเบสต์เซลเลอร์ด้านการพัฒนาตนเองและจิตวิทยาบำบัด'),
(3, 'วิศรุต การเงินดี', 'ที่ปรึกษาการลงทุนและผู้แต่งหนังสือการเงินบุคคล'),
(4, 'นลินทิพย์ นิยายฝัน', 'นักเขียนนิยายวรรณกรรมแปลและจินตนิยายชื่อดัง');

-- 5. เพิ่มข้อมูล E-Book (ebooks)
INSERT INTO ebooks (ebook_id, title, author_id, category_id, price, description, cover_image_url, file_download_url, is_active) VALUES
(1, 'Mastering SQL & Database Design', 1, 1, 350.00, 'คู่มือออกแบบฐานข้อมูลเชิงสัมพันธ์ตั้งแต่ศูนย์จนถึงขั้นสูง', 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&w=400&q=80', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 1),
(2, 'Modern Web Development with React', 1, 1, 420.00, 'สร้างเว็บแอปพลิเคชันยุคใหม่ด้วย React และ REST API', 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?auto=format&fit=crop&w=400&q=80', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 1),
(3, 'Python Data Analysis for Beginners', 1, 1, 380.00, 'วิเคราะห์ข้อมูลเบื้องต้นด้วย Python, Pandas และ Visualization', 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?auto=format&fit=crop&w=400&q=80', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 1),
(4, 'การเงินง่ายๆ สำหรับมนุษย์เงินเดือน', 3, 2, 250.00, 'วางแผนเกษียณ จัดการภาษี และการสร้าง passive income', 'https://images.unsplash.com/photo-1553729459-efe14ef6055d?auto=format&fit=crop&w=400&q=80', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 1),
(5, 'Startup Blueprint: จาก 0 สู่ 100 ล้าน', 3, 2, 320.00, 'ถอดรหัสวิธีคิดธุรกิจและกลยุทธ์การขยายตลาดแบบก้าวกระโดด', 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?auto=format&fit=crop&w=400&q=80', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 1),
(6, 'Digital Marketing Strategy 2026', 3, 2, 290.00, 'เทคนิคยิงแอดและการตลาดออนไลน์ให้ได้ผลตอบแทนสูงสุด', 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?auto=format&fit=crop&w=400&q=80', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 1),
(7, 'Atomic Habits: พลังแห่งนิสัยเล็กๆ', 2, 3, 280.00, 'เปลี่ยนแปลงชีวิตให้ดีขึ้นอย่างยั่งยืนด้วยการปรับพฤติกรรมทีละ 1%', 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?auto=format&fit=crop&w=400&q=80', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 1),
(8, 'The Art of Deep Work: ทำงานให้สำเร็จ', 2, 3, 270.00, 'สร้างสมาธิขั้นสูงในยุคที่เต็มไปด้วยสิ่งรบกวน', 'https://images.unsplash.com/photo-1499750310107-5fef28a66643?auto=format&fit=crop&w=400&q=80', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 1),
(9, 'จิตวิทยาการสื่อสารในที่ทำงาน', 2, 3, 260.00, 'วิธีพูดเพื่อโน้มน้าวใจและแก้ไขความขัดแย้งในทีมงาน', 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&w=400&q=80', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 1),
(10, 'มังกรไร้เงา ภาค 1: กำเนิดแดนสนธยา', 4, 4, 220.00, 'นิยายแฟนตาซีการผจญภัยในโลกเวทมนตร์โบราณ', 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?auto=format&fit=crop&w=400&q=80', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 1),
(11, 'มังกรไร้เงา ภาค 2: ศึกบัลลังก์มนตรา', 4, 4, 240.00, 'ภาคต่อสุดเข้มข้นของการต่อสู้ชิงบัลลังก์จักรวรรดิ', 'https://images.unsplash.com/photo-1514533450685-4493e01d1fdc?auto=format&fit=crop&w=400&q=80', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 1),
(12, 'คดีฆาตกรรมห้องสมุดลับโบราณ', 4, 4, 230.00, 'นวนิยายสืบสวนระทึกขวัญ ไขปริศนาฆาตกรรมห้องปิดตาย', 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?auto=format&fit=crop&w=400&q=80', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 1);

-- 6. เพิ่มข้อมูลคำสั่งซื้อ 32 ออเดอร์ (orders)
INSERT INTO orders (order_id, user_id, total_amount, order_status, order_datetime) VALUES
(1,  2, 350.00, 'confirmed', '2026-08-01 10:15:00'),
(2,  3, 670.00, 'confirmed', '2026-08-02 11:20:00'),
(3,  4, 250.00, 'confirmed', '2026-08-03 14:05:00'),
(4,  5, 800.00, 'confirmed', '2026-08-04 09:30:00'),
(5,  6, 280.00, 'confirmed', '2026-08-05 16:45:00'),
(6,  7, 460.00, 'confirmed', '2026-08-06 13:10:00'),
(7,  8, 380.00, 'confirmed', '2026-08-07 15:25:00'),
(8,  9, 320.00, 'confirmed', '2026-08-08 18:40:00'),
(9,  10, 230.00, 'confirmed', '2026-08-09 12:00:00'),
(10, 2, 700.00, 'confirmed', '2026-08-10 17:15:00'),
(11, 3, 290.00, 'confirmed', '2026-08-11 10:50:00'),
(12, 4, 530.00, 'confirmed', '2026-08-12 11:35:00'),
(13, 5, 350.00, 'confirmed', '2026-08-13 14:20:00'),
(14, 6, 550.00, 'confirmed', '2026-08-14 16:00:00'),
(15, 7, 240.00, 'confirmed', '2026-08-15 19:30:00'),
(16, 8, 420.00, 'confirmed', '2026-08-16 08:45:00'),
(17, 9, 250.00, 'confirmed', '2026-08-17 13:15:00'),
(18, 10, 280.00, 'confirmed', '2026-08-18 20:10:00'),
(19, 2, 260.00, 'confirmed', '2026-08-19 15:40:00'),
(20, 3, 350.00, 'confirmed', '2026-08-20 12:25:00'),
(21, 4, 380.00, 'confirmed', '2026-08-21 17:50:00'),
(22, 5, 220.00, 'confirmed', '2026-08-22 10:05:00'),
(23, 6, 320.00, 'confirmed', '2026-08-23 11:15:00'),
(24, 7, 270.00, 'confirmed', '2026-08-24 14:30:00'),
(25, 8, 250.00, 'confirmed', '2026-08-25 18:20:00'),
(26, 9, 770.00, 'confirmed', '2026-08-26 16:10:00'),
(27, 10, 460.00, 'confirmed', '2026-08-27 13:45:00'),
(28, 2, 420.00, 'confirmed', '2026-08-28 09:20:00'),
(29, 3, 350.00, 'pending',   '2026-08-29 11:00:00'),
(30, 4, 280.00, 'pending',   '2026-08-29 15:30:00'),
(31, 5, 380.00, 'cancelled', '2026-08-30 10:15:00'),
(32, 6, 250.00, 'cancelled', '2026-08-30 16:40:00');

-- 7. เพิ่มข้อมูลรายละเอียดรายการในคำสั่งซื้อ (order_items)
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

-- 8. เพิ่มข้อมูลการชำระเงิน (payments)
INSERT INTO payments (payment_id, order_id, payment_method, slip_image_url, is_verified) VALUES
(1,  1,  'พร้อมเพย์ QR', 'https://picsum.photos/seed/slip1/400/600', 1),
(2,  2,  'พร้อมเพย์ QR', 'https://picsum.photos/seed/slip2/400/600', 1),
(3,  3,  'โอนผ่านธนาคาร',  'https://picsum.photos/seed/slip3/400/600', 1),
(4,  4,  'พร้อมเพย์ QR', 'https://picsum.photos/seed/slip4/400/600', 1),
(5,  5,  'โอนผ่านธนาคาร',  'https://picsum.photos/seed/slip5/400/600', 1),
(6,  6,  'พร้อมเพย์ QR', 'https://picsum.photos/seed/slip6/400/600', 1),
(7,  7,  'พร้อมเพย์ QR', 'https://picsum.photos/seed/slip7/400/600', 1),
(8,  8,  'โอนผ่านธนาคาร',  'https://picsum.photos/seed/slip8/400/600', 1),
(9,  9,  'พร้อมเพย์ QR', 'https://picsum.photos/seed/slip9/400/600', 1),
(10, 10, 'พร้อมเพย์ QR', 'https://picsum.photos/seed/slip10/400/600', 1),
(11, 11, 'โอนผ่านธนาคาร',  'https://picsum.photos/seed/slip11/400/600', 1),
(12, 12, 'พร้อมเพย์ QR', 'https://picsum.photos/seed/slip12/400/600', 1),
(13, 13, 'พร้อมเพย์ QR', 'https://picsum.photos/seed/slip13/400/600', 1),
(14, 14, 'โอนผ่านธนาคาร',  'https://picsum.photos/seed/slip14/400/600', 1),
(15, 15, 'พร้อมเพย์ QR', 'https://picsum.photos/seed/slip15/400/600', 1),
(16, 16, 'โอนผ่านธนาคาร',  'https://picsum.photos/seed/slip16/400/600', 1),
(17, 17, 'พร้อมเพย์ QR', 'https://picsum.photos/seed/slip17/400/600', 1),
(18, 18, 'พร้อมเพย์ QR', 'https://picsum.photos/seed/slip18/400/600', 1),
(19, 19, 'โอนผ่านธนาคาร',  'https://picsum.photos/seed/slip19/400/600', 1),
(20, 20, 'พร้อมเพย์ QR', 'https://picsum.photos/seed/slip20/400/600', 1),
(21, 21, 'พร้อมเพย์ QR', 'https://picsum.photos/seed/slip21/400/600', 1),
(22, 22, 'โอนผ่านธนาคาร',  'https://picsum.photos/seed/slip22/400/600', 1),
(23, 23, 'พร้อมเพย์ QR', 'https://picsum.photos/seed/slip23/400/600', 1),
(24, 24, 'พร้อมเพย์ QR', 'https://picsum.photos/seed/slip24/400/600', 1),
(25, 25, 'โอนผ่านธนาคาร',  'https://picsum.photos/seed/slip25/400/600', 1),
(26, 26, 'พร้อมเพย์ QR', 'https://picsum.photos/seed/slip26/400/600', 1),
(27, 27, 'พร้อมเพย์ QR', 'https://picsum.photos/seed/slip27/400/600', 1),
(28, 28, 'โอนผ่านธนาคาร',  'https://picsum.photos/seed/slip28/400/600', 1),
(29, 29, 'พร้อมเพย์ QR', 'https://picsum.photos/seed/slip29/400/600', 0),
(30, 30, 'โอนผ่านธนาคาร',  'https://picsum.photos/seed/slip30/400/600', 0),
(31, 31, 'พร้อมเพย์ QR', NULL, 0),
(32, 32, 'โอนผ่านธนาคาร',  NULL, 0);

-- 9. เพิ่มข้อมูลสิทธิ์และลิงก์ดาวน์โหลด (download_links) เฉพาะคำสั่งซื้อที่ confirmed
INSERT INTO download_links (link_id, order_id, ebook_id, user_id, download_url, download_token, is_active) VALUES
(1,  1,  1,  2,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_001_sql', 1),
(2,  2,  2,  3,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_002_react', 1),
(3,  2,  4,  3,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_003_fin', 1),
(4,  3,  4,  4,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_004_fin', 1),
(5,  4,  2,  5,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_005_react', 1),
(6,  4,  3,  5,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_006_py', 1),
(7,  5,  7,  6,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_007_habits', 1),
(8,  6,  10, 7,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_008_dragon1', 1),
(9,  6,  11, 7,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_009_dragon2', 1),
(10, 7,  3,  8,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_010_py', 1),
(11, 8,  5,  9,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_011_startup', 1),
(12, 9,  12, 10, 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_012_mystery', 1),
(13, 10, 1,  2,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_013_sql', 1),
(14, 11, 6,  3,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_014_mkt', 1),
(15, 12, 7,  4,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_015_habits', 1),
(16, 12, 4,  4,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_016_fin', 1),
(17, 13, 1,  5,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_017_sql', 1),
(18, 14, 8,  6,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_018_deep', 1),
(19, 14, 7,  6,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_019_habits', 1),
(20, 15, 11, 7,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_020_dragon2', 1),
(21, 16, 2,  8,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_021_react', 1),
(22, 17, 4,  9,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_022_fin', 1),
(23, 18, 7,  10, 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_023_habits', 1),
(24, 19, 9,  2,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_024_comm', 1),
(25, 20, 1,  3,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_025_sql', 1),
(26, 21, 3,  4,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_026_py', 1),
(27, 22, 10, 5,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_027_dragon1', 1),
(28, 23, 5,  6,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_028_startup', 1),
(29, 24, 8,  7,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_029_deep', 1),
(30, 25, 4,  8,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_030_fin', 1),
(31, 26, 1,  9,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_031_sql', 1),
(32, 26, 2,  9,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_032_react', 1),
(33, 27, 10, 10, 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_033_dragon1', 1),
(34, 27, 11, 10, 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_034_dragon2', 1),
(35, 28, 2,  2,  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'tok_dl_035_react', 1);