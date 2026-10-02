import sqlite3
import os
import sys

if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8')

db_path = 'database/bookie_house.db'
if os.path.exists(db_path):
    try:
        os.remove(db_path)
    except Exception:
        pass

con = sqlite3.connect(db_path)
cur = con.cursor()

# 1. สร้างตารางทั้งหมด (SQLite Schema)
cur.executescript("""
CREATE TABLE IF NOT EXISTS roles (
    role_id INTEGER PRIMARY KEY AUTOINCREMENT,
    role_name TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS users (
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    role_id INTEGER NOT NULL DEFAULT 2,
    username TEXT NOT NULL UNIQUE,
    email TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    full_name TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES roles(role_id)
);

CREATE TABLE IF NOT EXISTS categories (
    category_id INTEGER PRIMARY KEY AUTOINCREMENT,
    category_name TEXT NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE IF NOT EXISTS authors (
    author_id INTEGER PRIMARY KEY AUTOINCREMENT,
    author_name TEXT NOT NULL,
    bio TEXT
);

CREATE TABLE IF NOT EXISTS ebooks (
    ebook_id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    author_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    price REAL NOT NULL DEFAULT 0.00,
    description TEXT,
    cover_image_url TEXT,
    file_download_url TEXT DEFAULT 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
    is_active INTEGER NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (author_id) REFERENCES authors(author_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE IF NOT EXISTS orders (
    order_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    total_amount REAL NOT NULL DEFAULT 0.00,
    order_status TEXT NOT NULL DEFAULT 'pending',
    order_datetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE IF NOT EXISTS order_items (
    item_id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id INTEGER NOT NULL,
    ebook_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1,
    price_per_unit REAL NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (ebook_id) REFERENCES ebooks(ebook_id)
);

CREATE TABLE IF NOT EXISTS payments (
    payment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id INTEGER NOT NULL UNIQUE,
    payment_method TEXT NOT NULL,
    slip_image_url TEXT,
    is_verified INTEGER NOT NULL DEFAULT 0,
    payment_datetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE IF NOT EXISTS download_links (
    link_id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id INTEGER NOT NULL,
    ebook_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    download_url TEXT NOT NULL,
    download_token TEXT NOT NULL,
    is_active INTEGER NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (ebook_id) REFERENCES ebooks(ebook_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
""")

# 2. นำเข้าข้อมูล Seed Data จาก setup_all_tables.sql
with open('database/setup_all_tables.sql', 'r', encoding='utf-8') as f:
    sql_content = f.read()

for chunk in sql_content.split(';'):
    clean = chunk.strip()
    idx = clean.upper().find('INSERT INTO')
    if idx != -1:
        stmt = clean[idx:]
        try:
            # ปรับค่า boolean ของ postgres เป็น 1/0 สำหรับ sqlite
            stmt_sqlite = stmt.replace('true', '1').replace('false', '0').replace('TRUE', '1').replace('FALSE', '0')
            cur.execute(stmt_sqlite)
        except Exception as e:
            print(f"Insert error: {e}")

con.commit()

def run_query(title, sql):
    print(f"\n========================================================")
    print(f"📊 {title}")
    print(f"========================================================")
    try:
        cur.execute(sql)
        rows = cur.fetchall()
        headers = [desc[0] for desc in cur.description]
        print(f"{' | '.join(headers)}")
        print("-" * 55)
        for row in rows:
            print(" | ".join(str(val) for val in row))
    except Exception as e:
        print(f"Error: {e}")

# 1. รายงานยอดขายตามช่วงเวลา (วัน)
q1 = """
SELECT 
    SUBSTR(order_datetime, 1, 10) AS sales_date,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(total_amount), 2) AS daily_sales,
    ROUND(AVG(total_amount), 2) AS avg_order_value
FROM orders
WHERE order_status = 'confirmed'
GROUP BY SUBSTR(order_datetime, 1, 10)
ORDER BY sales_date DESC;
"""

# 2. รายงาน E-Book ขายดี Top 5
q2 = """
SELECT 
    e.title,
    SUM(oi.quantity) AS total_sold,
    ROUND(SUM(oi.quantity * oi.price_per_unit), 2) AS total_revenue
FROM order_items oi
JOIN ebooks e ON oi.ebook_id = e.ebook_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'confirmed'
GROUP BY e.ebook_id, e.title
ORDER BY total_sold DESC
LIMIT 5;
"""

# 3. รายงานยอดขายตามหมวดหมู่
q3 = """
SELECT 
    c.category_name,
    COUNT(oi.item_id) AS items_sold,
    ROUND(SUM(oi.quantity * oi.price_per_unit), 2) AS category_revenue
FROM categories c
JOIN ebooks e ON c.category_id = e.category_id
JOIN order_items oi ON e.ebook_id = oi.ebook_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'confirmed'
GROUP BY c.category_id, c.category_name
ORDER BY category_revenue DESC;
"""

# 4. รายงานลูกค้าชั้นดีที่มียอดซื้อสูงสุด (Top Spenders)
q4 = """
SELECT 
    u.full_name,
    u.email,
    COUNT(o.order_id) AS orders_count,
    ROUND(SUM(o.total_amount), 2) AS total_spent
FROM users u
JOIN orders o ON u.user_id = o.user_id
WHERE o.order_status = 'confirmed'
GROUP BY u.user_id, u.full_name, u.email
HAVING total_spent > 0
ORDER BY total_spent DESC;
"""

# 5. สรุปตาราง download_links
q5 = """
SELECT 
    COUNT(link_id) AS total_links,
    COUNT(DISTINCT order_id) AS orders_with_links,
    COUNT(DISTINCT user_id) AS users_with_links
FROM download_links
WHERE is_active = 1;
"""

print("\n--- กำลังทดสอบดึงรายงานและตรวจสอบฐานข้อมูล Bookie House ---")
run_query("รายงานที่ 1: ยอดขายตามช่วงเวลา", q1)
run_query("รายงานที่ 2: E-Book ขายดี 5 อันดับแรก", q2)
run_query("รายงานที่ 3: ยอดขายตามหมวดหมู่", q3)
run_query("รายงานที่ 4: สรุปลูกค้าและยอดซื้อสะสม", q4)
run_query("รายงานที่ 5: สรุปตาราง download_links", q5)

con.close()