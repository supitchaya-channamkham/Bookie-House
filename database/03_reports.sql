-- ========================================================
-- Mini Project: Bookie House - E-Book Store Database
-- File: 03_reports.sql
-- Description: 4 Analytical SQL Reports as required by rubric
-- ========================================================

USE bookie_house_db;

-- --------------------------------------------------------
-- รายงานที่ 1: ยอดขายตามช่วงเวลา (Sales over Time)
-- คำถาม: ยอดขาย จำนวนคำสั่งซื้อ และค่าเฉลี่ยต่อคำสั่งซื้อเปลี่ยนไปอย่างไรตามวันที่
-- คำสั่งที่ใช้: JOIN, GROUP BY, SUM, COUNT, AVG, DATE()
-- --------------------------------------------------------
SELECT 
    DATE(order_datetime) AS sales_date,
    COUNT(order_id) AS total_orders,
    SUM(total_amount) AS daily_revenue,
    ROUND(AVG(total_amount), 2) AS average_order_value
FROM orders
WHERE order_status = 'confirmed'
GROUP BY DATE(order_datetime)
ORDER BY sales_date ASC;

-- --------------------------------------------------------
-- รายงานที่ 2: E-Book ขายดี (Top-Selling E-Books)
-- คำถาม: E-Book ใดขายได้มากที่สุดตามจำนวนเล่มและยอดขายรวม (5 อันดับแรก)
-- คำสั่งที่ใช้: JOIN, GROUP BY, SUM, LIMIT
-- --------------------------------------------------------
SELECT 
    e.ebook_id,
    e.title,
    a.author_name,
    SUM(oi.quantity) AS total_copies_sold,
    SUM(oi.quantity * oi.price_per_unit) AS total_sales_amount
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN ebooks e ON oi.ebook_id = e.ebook_id
JOIN authors a ON e.author_id = a.author_id
WHERE o.order_status = 'confirmed'
GROUP BY e.ebook_id, e.title, a.author_name
ORDER BY total_copies_sold DESC, total_sales_amount DESC
LIMIT 5;

-- --------------------------------------------------------
-- รายงานที่ 3: ยอดขายตามหมวดหมู่ (Sales by Category)
-- คำถาม: หมวดหมู่ใดสร้างยอดขายและจำนวนเล่มที่ขายได้สูงสุด
-- คำสั่งที่ใช้: JOIN หลายตาราง, GROUP BY, SUM
-- --------------------------------------------------------
SELECT 
    c.category_id,
    c.category_name,
    COUNT(DISTINCT o.order_id) AS total_distinct_orders,
    SUM(oi.quantity) AS total_items_sold,
    SUM(oi.quantity * oi.price_per_unit) AS total_category_revenue
FROM categories c
JOIN ebooks e ON c.category_id = e.category_id
JOIN order_items oi ON e.ebook_id = oi.ebook_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'confirmed'
GROUP BY c.category_id, c.category_name
ORDER BY total_category_revenue DESC;

-- --------------------------------------------------------
-- รายงานที่ 4: พฤติกรรมลูกค้าและสถานะคำสั่งซื้อ (Customer Behavior & Order Status)
-- คำถาม: ลูกค้ารายใดมียอดซื้อสะสมสูง (ยอดรวมตั้งแต่ 500 บาทขึ้นไป) พร้อมสรุปสถานะออเดอร์
-- คำสั่งที่ใช้: JOIN, GROUP BY, HAVING, COUNT, SUM, CASE WHEN
-- --------------------------------------------------------
SELECT 
    u.user_id,
    u.full_name,
    u.email,
    COUNT(o.order_id) AS total_orders,
    SUM(CASE WHEN o.order_status = 'confirmed' THEN 1 ELSE 0 END) AS confirmed_orders,
    SUM(CASE WHEN o.order_status = 'pending' THEN 1 ELSE 0 END) AS pending_orders,
    SUM(CASE WHEN o.order_status = 'cancelled' THEN 1 ELSE 0 END) AS cancelled_orders,
    SUM(CASE WHEN o.order_status = 'confirmed' THEN o.total_amount ELSE 0 END) AS total_spent
FROM users u
JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.full_name, u.email
HAVING total_spent >= 500.00
ORDER BY total_spent DESC;