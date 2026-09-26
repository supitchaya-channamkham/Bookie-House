import sqlite3

db_path = 'database/bookie_house.db'
con = sqlite3.connect(db_path)
cur = con.cursor()

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
    DATE(order_date) AS order_day,
    COUNT(order_id) AS total_orders,
    SUM(total_amount) AS daily_sales,
    ROUND(AVG(total_amount), 2) AS avg_order_value
FROM orders
WHERE status = 'confirmed'
GROUP BY DATE(order_date)
ORDER BY order_day DESC;
"""

# 2. รายงาน E-Book ขายดี Top 5
q2 = """
SELECT 
    e.title,
    SUM(oi.quantity) AS total_sold,
    SUM(oi.subtotal) AS total_revenue
FROM order_items oi
JOIN ebooks e ON oi.ebook_id = e.ebook_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'confirmed'
GROUP BY e.ebook_id, e.title
ORDER BY total_sold DESC
LIMIT 5;
"""

# 3. รายงานยอดขายตามหมวดหมู่
q3 = """
SELECT 
    c.category_name,
    COUNT(oi.order_item_id) AS items_sold,
    SUM(oi.subtotal) AS category_revenue
FROM categories c
JOIN ebooks e ON c.category_id = e.category_id
JOIN order_items oi ON e.ebook_id = oi.ebook_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'confirmed'
GROUP BY c.category_id, c.category_name
ORDER BY category_revenue DESC;
"""

# 4. รายงานลูกค้าชั้นดีที่มียอดซื้อสูงสุด (Top Spenders)
q4 = """
SELECT 
    u.full_name,
    u.email,
    COUNT(o.order_id) AS orders_count,
    SUM(o.total_amount) AS total_spent
FROM users u
JOIN orders o ON u.user_id = o.user_id
WHERE o.status = 'confirmed'
GROUP BY u.user_id, u.full_name, u.email
HAVING total_spent > 0
ORDER BY total_spent DESC;
"""

print("\n--- กำลังทดสอบดึง 4 รายงานจากฐานข้อมูล Bookie House ---")
run_query("รายงานที่ 1: ยอดขายตามช่วงเวลา", q1)
run_query("รายงานที่ 2: E-Book ขายดี 5 อันดับแรก", q2)
run_query("รายงานที่ 3: ยอดขายตามหมวดหมู่", q3)
run_query("รายงานที่ 4: สรุปลูกค้าและยอดซื้อสะสม", q4)

con.close()