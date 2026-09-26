-- ========================================================
-- Mini Project: Bookie House - E-Book Store Database
-- File: 02_seed_data.sql
-- Description: Realistic Seed Data (30+ Orders, Users, Books)
-- ========================================================

USE bookie_house_db;

-- 1. เพิ่มข้อมูลบทบาท (roles)
INSERT INTO roles (role_id, role_name) VALUES
(1, 'customer'),
(2, 'admin');

-- 2. เพิ่มข้อมูลผู้ใช้งาน (users)
INSERT INTO users (user_id, role_id, username, email, password_hash, full_name) VALUES
(1, 2, 'admin_bookie', 'admin@bookiehouse.com', '$2b$12$e8Yd8A9B1uF9Z.adminhashpass1', 'ผู้ดูแลระบบ Bookie House'),
(2, 1, 'somchai_s', 'somchai@gmail.com', '$2b$12$e8Yd8A9B1uF9Z.userhashpass02', 'สมชาย สายอ่าน'),
(3, 1, 'wanida_k', 'wanida@hotmail.com', '$2b$12$e8Yd8A9B1uF9Z.userhashpass03', 'วนิดา แก้วมณี'),
(4, 1, 'thanaporn_t', 'thanaporn@gmail.com', '$2b$12$e8Yd8A9B1uF9Z.userhashpass04', 'ธนพร ทรัพย์มั่นคง'),
(5, 1, 'kris_dev', 'kris@techmail.com', '$2b$12$e8Yd8A9B1uF9Z.userhashpass05', 'กฤษณะ พัฒนาการ'),
(6, 1, 'napat_m', 'napat@yahoo.com', '$2b$12$e8Yd8A9B1uF9Z.userhashpass06', 'ณภัทร มีสุข'),
(7, 1, 'arisa_read', 'arisa@outlook.com', '$2b$12$e8Yd8A9B1uF9Z.userhashpass07', 'อริสา รักการอ่าน'),
(8, 1, 'piti_b', 'piti@gmail.com', '$2b$12$e8Yd8A9B1uF9Z.userhashpass08', 'ปิติ บุญส่ง'),
(9, 1, 'pim_chanok', 'pim@gmail.com', '$2b$12$e8Yd8A9B1uF9Z.userhashpass09', 'พิมพ์ชนก นครศรี'),
(10, 1, 'chakrit_c', 'chakrit@gmail.com', '$2b$12$e8Yd8A9B1uF9Z.userhashpass10', 'ชาคริต ชัยชนะ');

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
(1, 'Mastering SQL & Database Design', 1, 1, 350.00, 'คู่มือออกแบบฐานข้อมูลเชิงสัมพันธ์ตั้งแต่ศูนย์จนถึงขั้นสูง', 'https://picsum.photos/seed/sql/300/400', 'https://storage.bookiehouse.com/dl/sql-master.pdf', 1),
(2, 'Modern Web Development with React', 1, 1, 420.00, 'สร้างเว็บแอปพลิเคชันยุคใหม่ด้วย React และ REST API', 'https://picsum.photos/seed/react/300/400', 'https://storage.bookiehouse.com/dl/react-web.pdf', 1),
(3, 'Python Data Analysis for Beginners', 1, 1, 380.00, 'วิเคราะห์ข้อมูลเบื้องต้นด้วย Python, Pandas และ Visualization', 'https://picsum.photos/seed/python/300/400', 'https://storage.bookiehouse.com/dl/python-data.pdf', 1),
(4, 'การเงินง่ายๆ สำหรับมนุษย์เงินเดือน', 3, 2, 250.00, 'วางแผนเกษียณ จัดการภาษี และการสร้าง passive income', 'https://picsum.photos/seed/finance/300/400', 'https://storage.bookiehouse.com/dl/finance-salary.pdf', 1),
(5, 'Startup Blueprint: จาก 0 สู่ 100 ล้าน', 3, 2, 320.00, 'ถอดรหัสวิธีคิดธุรกิจและกลยุทธ์การขยายตลาดแบบก้าวกระโดด', 'https://picsum.photos/seed/startup/300/400', 'https://storage.bookiehouse.com/dl/startup-bp.pdf', 1),
(6, 'Digital Marketing Strategy 2026', 3, 2, 290.00, 'เทคนิคยิงแอดและการตลาดออนไลน์ให้ได้ผลตอบแทนสูงสุด', 'https://picsum.photos/seed/marketing/300/400', 'https://storage.bookiehouse.com/dl/digital-mkt.pdf', 1),
(7, 'Atomic Habits: พลังแห่งนิสัยเล็กๆ', 2, 3, 280.00, 'เปลี่ยนแปลงชีวิตให้ดีขึ้นอย่างยั่งยืนด้วยการปรับพฤติกรรมทีละ 1%', 'https://picsum.photos/seed/habits/300/400', 'https://storage.bookiehouse.com/dl/atomic-habits.pdf', 1),
(8, 'The Art of Deep Work: ทำงานให้สำเร็จ', 2, 3, 270.00, 'สร้างสมาธิขั้นสูงในยุคที่เต็มไปด้วยสิ่งรบกวน', 'https://picsum.photos/seed/focus/300/400', 'https://storage.bookiehouse.com/dl/deep-work.pdf', 1),
(9, 'จิตวิทยาการสื่อสารในที่ทำงาน', 2, 3, 260.00, 'วิธีพูดเพื่อโน้มน้าวใจและแก้ไขความขัดแย้งในทีมงาน', 'https://picsum.photos/seed/comm/300/400', 'https://storage.bookiehouse.com/dl/work-comm.pdf', 1),
(10, 'มังกรไร้เงา ภาค 1: กำเนิดแดนสนธยา', 4, 4, 220.00, 'นิยายแฟนตาซีการผจญภัยในโลกเวทมนตร์โบราณ', 'https://picsum.photos/seed/fantasy1/300/400', 'https://storage.bookiehouse.com/dl/dragon-01.pdf', 1),
(11, 'มังกรไร้เงา ภาค 2: ศึกบัลลังก์มนตรา', 4, 4, 240.00, 'ภาคต่อสุดเข้มข้นของการต่อสู้ชิงบัลลังก์จักรวรรดิ', 'https://picsum.photos/seed/fantasy2/300/400', 'https://storage.bookiehouse.com/dl/dragon-02.pdf', 1),
(12, 'คดีฆาตกรรมห้องสมุดลับโบราณ', 4, 4, 230.00, 'นวนิยายสืบสวนระทึกขวัญ ไขปริศนาฆาตกรรมห้องปิดตาย', 'https://picsum.photos/seed/mystery/300/400', 'https://storage.bookiehouse.com/dl/library-mystery.pdf', 1);

-- 6. เพิ่มข้อมูลคำสั่งซื้อ 32 ออเดอร์ (orders)
INSERT INTO orders (order_id, user_id, total_amount, status, order_date) VALUES
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
INSERT INTO order_items (order_item_id, order_id, ebook_id, quantity, unit_price, subtotal) VALUES
(1,  1,  1,  1, 350.00, 350.00),
(2,  2,  2,  1, 420.00, 420.00),
(3,  2,  4,  1, 250.00, 250.00),
(4,  3,  4,  1, 250.00, 250.00),
(5,  4,  2,  1, 420.00, 420.00),
(6,  4,  3,  1, 380.00, 380.00),
(7,  5,  7,  1, 280.00, 280.00),
(8,  6,  10, 1, 220.00, 220.00),
(9,  6,  11, 1, 240.00, 240.00),
(10, 7,  3,  1, 380.00, 380.00),
(11, 8,  5,  1, 320.00, 320.00),
(12, 9,  12, 1, 230.00, 230.00),
(13, 10, 1,  2, 350.00, 700.00),
(14, 11, 6,  1, 290.00, 290.00),
(15, 12, 7,  1, 280.00, 280.00),
(16, 12, 4,  1, 250.00, 250.00),
(17, 13, 1,  1, 350.00, 350.00),
(18, 14, 8,  1, 270.00, 270.00),
(19, 14, 7,  1, 280.00, 280.00),
(20, 15, 11, 1, 240.00, 240.00),
(21, 16, 2,  1, 420.00, 420.00),
(22, 17, 4,  1, 250.00, 250.00),
(23, 18, 7,  1, 280.00, 280.00),
(24, 19, 9,  1, 260.00, 260.00),
(25, 20, 1,  1, 350.00, 350.00),
(26, 21, 3,  1, 380.00, 380.00),
(27, 22, 10, 1, 220.00, 220.00),
(28, 23, 5,  1, 320.00, 320.00),
(29, 24, 8,  1, 270.00, 270.00),
(30, 25, 4,  1, 250.00, 250.00),
(31, 26, 1,  1, 350.00, 350.00),
(32, 26, 2,  1, 420.00, 420.00),
(33, 27, 10, 1, 220.00, 220.00),
(34, 27, 11, 1, 240.00, 240.00),
(35, 28, 2,  1, 420.00, 420.00),
(36, 29, 1,  1, 350.00, 350.00),
(37, 30, 7,  1, 280.00, 280.00),
(38, 31, 3,  1, 380.00, 380.00),
(39, 32, 4,  1, 250.00, 250.00);

-- 8. เพิ่มข้อมูลการชำระเงินจำลอง (payments)
INSERT INTO payments (payment_id, order_id, payment_method, amount_paid, slip_image_url, payment_status) VALUES
(1,  1,  'promptpay_mock', 350.00, 'https://picsum.photos/seed/slip1/400/600', 'verified'),
(2,  2,  'promptpay_mock', 670.00, 'https://picsum.photos/seed/slip2/400/600', 'verified'),
(3,  3,  'bank_transfer',  250.00, 'https://picsum.photos/seed/slip3/400/600', 'verified'),
(4,  4,  'promptpay_mock', 800.00, 'https://picsum.photos/seed/slip4/400/600', 'verified'),
(5,  5,  'bank_transfer',  280.00, 'https://picsum.photos/seed/slip5/400/600', 'verified'),
(6,  6,  'promptpay_mock', 460.00, 'https://picsum.photos/seed/slip6/400/600', 'verified'),
(7,  7,  'promptpay_mock', 380.00, 'https://picsum.photos/seed/slip7/400/600', 'verified'),
(8,  8,  'bank_transfer',  320.00, 'https://picsum.photos/seed/slip8/400/600', 'verified'),
(9,  9,  'promptpay_mock', 230.00, 'https://picsum.photos/seed/slip9/400/600', 'verified'),
(10, 10, 'promptpay_mock', 700.00, 'https://picsum.photos/seed/slip10/400/600', 'verified'),
(11, 11, 'bank_transfer',  290.00, 'https://picsum.photos/seed/slip11/400/600', 'verified'),
(12, 12, 'promptpay_mock', 530.00, 'https://picsum.photos/seed/slip12/400/600', 'verified'),
(13, 13, 'promptpay_mock', 350.00, 'https://picsum.photos/seed/slip13/400/600', 'verified'),
(14, 14, 'bank_transfer',  550.00, 'https://picsum.photos/seed/slip14/400/600', 'verified'),
(15, 15, 'promptpay_mock', 240.00, 'https://picsum.photos/seed/slip15/400/600', 'verified'),
(16, 16, 'bank_transfer',  420.00, 'https://picsum.photos/seed/slip16/400/600', 'verified'),
(17, 17, 'promptpay_mock', 250.00, 'https://picsum.photos/seed/slip17/400/600', 'verified'),
(18, 18, 'promptpay_mock', 280.00, 'https://picsum.photos/seed/slip18/400/600', 'verified'),
(19, 19, 'bank_transfer',  260.00, 'https://picsum.photos/seed/slip19/400/600', 'verified'),
(20, 20, 'promptpay_mock', 350.00, 'https://picsum.photos/seed/slip20/400/600', 'verified'),
(21, 21, 'promptpay_mock', 380.00, 'https://picsum.photos/seed/slip21/400/600', 'verified'),
(22, 22, 'bank_transfer',  220.00, 'https://picsum.photos/seed/slip22/400/600', 'verified'),
(23, 23, 'promptpay_mock', 320.00, 'https://picsum.photos/seed/slip23/400/600', 'verified'),
(24, 24, 'promptpay_mock', 270.00, 'https://picsum.photos/seed/slip24/400/600', 'verified'),
(25, 25, 'bank_transfer',  250.00, 'https://picsum.photos/seed/slip25/400/600', 'verified'),
(26, 26, 'promptpay_mock', 770.00, 'https://picsum.photos/seed/slip26/400/600', 'verified'),
(27, 27, 'promptpay_mock', 460.00, 'https://picsum.photos/seed/slip27/400/600', 'verified'),
(28, 28, 'bank_transfer',  420.00, 'https://picsum.photos/seed/slip28/400/600', 'verified'),
(29, 29, 'promptpay_mock', 350.00, 'https://picsum.photos/seed/slip29/400/600', 'pending'),
(30, 30, 'bank_transfer',  280.00, 'https://picsum.photos/seed/slip30/400/600', 'pending'),
(31, 31, 'promptpay_mock', 380.00, NULL, 'rejected'),
(32, 32, 'bank_transfer',  250.00, NULL, 'rejected');

-- 9. เพิ่มข้อมูลลิงก์ดาวน์โหลด (download_links) เฉพาะคำสั่งซื้อที่ confirmed
INSERT INTO download_links (order_item_id, user_id, ebook_id, access_token, download_url, expires_at, download_count) VALUES
(1,  2,  1,  'tok_dl_001_sql',       'https://storage.bookiehouse.com/dl/sql-master.pdf',       '2026-12-31 23:59:59', 2),
(2,  3,  2,  'tok_dl_002_react',     'https://storage.bookiehouse.com/dl/react-web.pdf',        '2026-12-31 23:59:59', 1),
(3,  3,  4,  'tok_dl_003_fin',       'https://storage.bookiehouse.com/dl/finance-salary.pdf',   '2026-12-31 23:59:59', 0),
(4,  4,  4,  'tok_dl_004_fin',       'https://storage.bookiehouse.com/dl/finance-salary.pdf',   '2026-12-31 23:59:59', 1),
(5,  5,  2,  'tok_dl_005_react',     'https://storage.bookiehouse.com/dl/react-web.pdf',        '2026-12-31 23:59:59', 3),
(6,  5,  3,  'tok_dl_006_py',        'https://storage.bookiehouse.com/dl/python-data.pdf',      '2026-12-31 23:59:59', 0),
(7,  6,  7,  'tok_dl_007_habits',    'https://storage.bookiehouse.com/dl/atomic-habits.pdf',    '2026-12-31 23:59:59', 1),
(8,  7,  10, 'tok_dl_008_dragon1',   'https://storage.bookiehouse.com/dl/dragon-01.pdf',        '2026-12-31 23:59:59', 2),
(9,  7,  11, 'tok_dl_009_dragon2',   'https://storage.bookiehouse.com/dl/dragon-02.pdf',        '2026-12-31 23:59:59', 1),
(10, 8,  3,  'tok_dl_010_py',        'https://storage.bookiehouse.com/dl/python-data.pdf',      '2026-12-31 23:59:59', 0),
(11, 9,  5,  'tok_dl_011_startup',   'https://storage.bookiehouse.com/dl/startup-bp.pdf',       '2026-12-31 23:59:59', 1),
(12, 10, 12, 'tok_dl_012_mystery',   'https://storage.bookiehouse.com/dl/library-mystery.pdf',  '2026-12-31 23:59:59', 4),
(13, 2,  1,  'tok_dl_013_sql',       'https://storage.bookiehouse.com/dl/sql-master.pdf',       '2026-12-31 23:59:59', 1),
(14, 3,  6,  'tok_dl_014_mkt',       'https://storage.bookiehouse.com/dl/digital-mkt.pdf',      '2026-12-31 23:59:59', 0),
(15, 4,  7,  'tok_dl_015_habits',    'https://storage.bookiehouse.com/dl/atomic-habits.pdf',    '2026-12-31 23:59:59', 1),
(16, 4,  4,  'tok_dl_016_fin',       'https://storage.bookiehouse.com/dl/finance-salary.pdf',   '2026-12-31 23:59:59', 2),
(17, 5,  1,  'tok_dl_017_sql',       'https://storage.bookiehouse.com/dl/sql-master.pdf',       '2026-12-31 23:59:59', 0),
(18, 6,  8,  'tok_dl_018_deep',      'https://storage.bookiehouse.com/dl/deep-work.pdf',        '2026-12-31 23:59:59', 1),
(19, 6,  7,  'tok_dl_019_habits',    'https://storage.bookiehouse.com/dl/atomic-habits.pdf',    '2026-12-31 23:59:59', 0),
(20, 7,  11, 'tok_dl_020_dragon2',   'https://storage.bookiehouse.com/dl/dragon-02.pdf',        '2026-12-31 23:59:59', 2),
(21, 8,  2,  'tok_dl_021_react',     'https://storage.bookiehouse.com/dl/react-web.pdf',        '2026-12-31 23:59:59', 1),
(22, 9,  4,  'tok_dl_022_fin',       'https://storage.bookiehouse.com/dl/finance-salary.pdf',   '2026-12-31 23:59:59', 0),
(23, 10, 7,  'tok_dl_023_habits',    'https://storage.bookiehouse.com/dl/atomic-habits.pdf',    '2026-12-31 23:59:59', 1),
(24, 2,  9,  'tok_dl_024_comm',      'https://storage.bookiehouse.com/dl/work-comm.pdf',        '2026-12-31 23:59:59', 0),
(25, 3,  1,  'tok_dl_025_sql',       'https://storage.bookiehouse.com/dl/sql-master.pdf',       '2026-12-31 23:59:59', 1),
(26, 4,  3,  'tok_dl_026_py',        'https://storage.bookiehouse.com/dl/python-data.pdf',      '2026-12-31 23:59:59', 2),
(27, 5,  10, 'tok_dl_027_dragon1',   'https://storage.bookiehouse.com/dl/dragon-01.pdf',        '2026-12-31 23:59:59', 1),
(28, 6,  5,  'tok_dl_028_startup',   'https://storage.bookiehouse.com/dl/startup-bp.pdf',       '2026-12-31 23:59:59', 0),
(29, 7,  8,  'tok_dl_029_deep',      'https://storage.bookiehouse.com/dl/deep-work.pdf',        '2026-12-31 23:59:59', 3),
(30, 8,  4,  'tok_dl_030_fin',       'https://storage.bookiehouse.com/dl/finance-salary.pdf',   '2026-12-31 23:59:59', 1),
(31, 9,  1,  'tok_dl_031_sql',       'https://storage.bookiehouse.com/dl/sql-master.pdf',       '2026-12-31 23:59:59', 0),
(32, 9,  2,  'tok_dl_032_react',     'https://storage.bookiehouse.com/dl/react-web.pdf',        '2026-12-31 23:59:59', 1),
(33, 10, 10, 'tok_dl_033_dragon1',   'https://storage.bookiehouse.com/dl/dragon-01.pdf',        '2026-12-31 23:59:59', 0),
(34, 10, 11, 'tok_dl_034_dragon2',   'https://storage.bookiehouse.com/dl/dragon-02.pdf',        '2026-12-31 23:59:59', 1),
(35, 2,  2,  'tok_dl_035_react',     'https://storage.bookiehouse.com/dl/react-web.pdf',        '2026-12-31 23:59:59', 2);