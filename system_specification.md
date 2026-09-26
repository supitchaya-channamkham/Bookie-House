# ข้อกำหนดระบบ (System Specification)
## โครงงานฐานข้อมูล: ระบบร้านค้า E-Book ออนไลน์ (E-Book Store Mini Project)

---

### 1. ข้อมูลโครงงาน (Project Overview)
- **ประเภทโครงงาน:** Web Application & Database Management System (DBMS)
- **จำนวนสมาชิก:** 2 คน
- **เป้าหมาย:** พัฒนาระบบร้านค้าหนังสือดิจิทัล (E-Book) ที่รองรับกระบวนการค้นหา สั่งซื้อ ชำระเงินแบบจำลอง การควบคุมสิทธิ์การดาวน์โหลดอย่างรัดกุม การจัดการส่วนหลังบ้าน และการสร้างรายงานวิเคราะห์เชิงธุรกิจด้วยภาษา SQL

---

### 2. ขอบเขตของระบบ (System Scope)

#### 2.1 ขอบเขตที่ระบบต้องรองรับ (In-Scope)
1. **ระบบบริหารจัดการผู้ใช้ (Authentication & Authorization):**
   - การลงทะเบียนสมาชิก (Customer) และการเข้าสู่ระบบ
   - การแบ่งสิทธิ์ (Role-Based Access Control) อย่างน้อย 2 บทบาท: `customer` และ `admin`
   - การจัดการโปรไฟล์และประวัติการสั่งซื้อ
2. **ระบบหน้าร้านและการเลือกซื้อ (Catalog & Shopping Cart):**
   - แสดงรายการ E-Book พร้อมรายละเอียด: ชื่อเรื่อง, ผู้แต่ง, หมวดหมู่, ราคา, คำอธิบาย, รูปภาพปก, สถานะเปิด/ปิดการขาย
   - ค้นหาด้วยชื่อหนังสือ/คำสำคัญ และกรอง (Filter) ตามหมวดหมู่
   - ระบบตะกร้าสินค้า: เพิ่ม, ลดจำนวน, ลบรายการ และคำนวณราคารวม
3. **ระบบสั่งซื้อและการชำระเงินจำลอง (Order & Simulated Payment):**
   - สร้างใบสั่งซื้อ บันทึกรายการย่อย และคำนวณยอดเงินรวมสุทธิ
   - กระบวนการชำระเงินจำลอง (Simulated Payment) โดยให้ผู้ใช้เลือกช่องทาง (เช่น โอนเงินผ่านธนาคารจำลอง) และแนบหลักฐานการโอนจำลอง (Mock Slip Image/Text)
   - *คำเตือนด้านความปลอดภัย:* ไม่มีการเก็บข้อมูลบัตรเครดิตหรือบัญชีการเงินจริง
4. **การควบคุมการเข้าถึงลิงก์ดาวน์โหลด (Digital Delivery & Access Control):**
   - ลูกค้าสามารถเข้าถึง URL ดาวน์โหลดได้ **เฉพาะเมื่อสถานะคำสั่งซื้อเป็น `PAID` / `CONFIRMED` แล้วเท่านั้น**
   - ระบบบล็อกการเข้าถึงลิงก์ในระดับ Database Query และ Application Logic หากคำสั่งซื้อยังอยู่ในสถานะ `PENDING`, `CANCELLED` หรือยังไม่ได้ซื้อ
5. **ระบบบริหารจัดการหลังบ้าน (Back-Office Administration):**
   - จัดการข้อมูล E-Book (CRUD, ตั้งราคา, กำหนด URL ดาวน์โหลด, เปิด/ปิดการขาย)
   - จัดการหมวดหมู่ (Categories)
   - จัดการคำสั่งซื้อ (ตรวจสอบหลักฐานจำลอง, ปรับสถานะคำสั่งซื้อเป็น `PENDING`, `CONFIRMED`, `CANCELLED`)
   - จัดการผู้ใช้งานและสิทธิ์
   - หน้าแดชบอร์ดสรุปยอดขายและข้อมูลสถิติ
6. **รายงานวิเคราะห์ข้อมูล (Analytical Reports):**
   - สร้างรายงานวิเคราะห์อย่างน้อย 4 หัวข้อโดยใช้คำสั่ง SQL ขั้นสูง จากข้อมูลตัวอย่างจริงในระบบ

#### 2.2 ขอบเขตที่ไม่ต้องพัฒนา (Out-of-Scope)
- การเชื่อมต่อ Payment Gateway จริง (ใช้วิธีแนบสลิป/กดยืนยันจำลอง)
- ระบบจัดการสิทธิ์ดิจิทัลขั้นสูง (DRM: Digital Rights Management)
- พื้นที่จัดเก็บไฟล์ขนาดใหญ่จริง (ใช้ Mock Storage URL หรือลิงก์ภายนอกที่ได้รับอนุญาต)
- ระบบส่งอีเมลแจ้งเตือนจริง (SMTP Server จริง)
- Mobile Application แบบ Native (เน้น Responsive Web Application)

---

### 3. ข้อกำหนดเชิงฟังก์ชัน (Functional Requirements - FR)
- **FR-01:** ระบบต้องตรวจสอบความซ้ำซ้อนของอีเมลขณะสมัครสมาชิก
- **FR-02:** ลูกค้าต้องสามารถค้นหา E-Book และกรองข้อมูลตามหมวดหมู่ได้
- **FR-03:** ระบบต้องบันทึกรายการสินค้าในตะกร้าแยกตามบัญชีผู้ใช้
- **FR-04:** เมื่อยืนยันการสั่งซื้อ ระบบต้องสร้าง `orders` และ `order_items` พร้อมบันทึกราคา ณ เวลาที่สั่งซื้อ (Snapshot Price)
- **FR-05:** ระบบต้องมีหน้าจอให้ Admin ตรวจสอบคำสั่งซื้อและเปลี่ยนสถานะเป็น `CONFIRMED`
- **FR-06:** ลิงก์ดาวน์โหลดต้องถูกแสดงในหน้าประวัติคำสั่งซื้อเฉพาะรายการที่มีสถานะ `CONFIRMED` เท่านั้น
- **FR-07:** Admin ต้องสามารถเปิดหรือปิดการขาย E-Book แต่ละเล่มได้ โดย E-Book ที่ปิดการขายต้องไม่แสดงในหน้าร้าน

---

### 4. ข้อกำหนดเชิงคุณภาพ/ที่ไม่ใช่ฟังก์ชัน (Non-Functional Requirements - NFR)
- **NFR-01 (Data Integrity):** โครงสร้างฐานข้อมูลต้องสอดคล้องกับหลัก Normalization ระดับ Third Normal Form (3NF)
- **NFR-02 (Security & Constraints):** กำหนด Primary Key, Foreign Key, `NOT NULL`, `UNIQUE`, และ `CHECK` constraint (เช่น ราคาต้องมากกว่าหรือเท่ากับ 0) ในทุกตารางที่เกี่ยวข้อง
- **NFR-03 (Performance):** SQL Query สำหรับหน้าร้านและรายงานต้องทำงานได้อย่างรวดเร็ว โดยมีการสร้าง Index บน Foreign Key และคอลัมน์ค้นหาหลัก
- **NFR-04 (Usability):** หน้าจอ UI ต้องรองรับการทำงานทั้งบน Desktop และ Mobile Browser ได้อย่างราบรื่น
- **NFR-05 (Seed Data Scale):** ต้องมีข้อมูลตัวอย่างที่สมบูรณ์ โดยมีคำสั่งซื้อไม่น้อยกว่า 30 รายการ กระจายสถานะและช่วงเวลาอย่างสมเหตุสมผล

---

### 5. สถาปัตยกรรมฐานข้อมูล (Database Schema & Architecture)
โครงสร้างฐานข้อมูลออกแบบตามหลัก 3NF ประกอบด้วย **11 ตาราง** (เกินเกณฑ์ขั้นต่ำ 8 ตารางของโจทย์):

```
       +-----------------+
       |      roles      |
       +--------+--------+
                | 1
                | N
       +--------+--------+               +------------------+
       |      users      +---------------+      carts       |
       +--------+--------+ 1           1 +--------+---------+
                | 1                               | 1
                | N                               | N
       +--------+--------+               +--------+---------+
       |     orders      |               |    cart_items    |
       +---+----+----+---+               +--------+---------+
           | 1  | 1  | 1                          | N
           | N  | 1  | N                          |
           |    |    +-------+                    |
           |    |            |                    |
           |    |     +------+------+             |
           |    |     |  payments   |             |
           |    |     +-------------+             |
           |    |                                 |
           |    +---------------+                 |
           | 1                  | 1               |
           | N                  | N               |
+----------+----+     +---------+------+          |
|  order_items  |     | download_links |          |
+----------+----+     +---------+------+          |
           | N                  | N               |
           +----------+---------+                 |
                      | 1                         |
                      |                           |
             +--------+---------+                 |
             |      ebooks      +-----------------+
             +----+---------+---+ 1
                N |         | N
                  |         |
                  | 1       | 1
+-----------------+--+   +--+---------------+
|   categories       |   |     authors      |
+--------------------+   +------------------+
```

#### รายละเอียดโครงสร้างตาราง (Data Dictionary Summary)
1. **`roles`**: รหัสและชื่อสิทธิ์ (`role_id` [PK], `role_name` [UNIQUE])
2. **`users`**: ข้อมูลบัญชีผู้ใช้ (`user_id` [PK], `role_id` [FK], `email` [UNIQUE], `password_hash`, `full_name`, `created_at`)
3. **`categories`**: หมวดหมู่ E-Book (`category_id` [PK], `category_name` [UNIQUE], `description`)
4. **`authors`**: ข้อมูลนักเขียน (`author_id` [PK], `author_name`, `biography`)
5. **`ebooks`**: รายการหนังสือ (`ebook_id` [PK], `category_id` [FK], `author_id` [FK], `title`, `price` [CHECK >= 0], `cover_image_url`, `description`, `is_published`, `created_at`)
6. **`carts`**: ตะกร้าสินค้าของผู้ใช้ (`cart_id` [PK], `user_id` [FK, UNIQUE], `updated_at`)
7. **`cart_items`**: รายการในตะกร้า (`cart_item_id` [PK], `cart_id` [FK], `ebook_id` [FK], `quantity` [CHECK > 0], `created_at`)
8. **`orders`**: ข้อมูลคำสั่งซื้อ (`order_id` [PK], `user_id` [FK], `order_date`, `total_amount` [CHECK >= 0], `order_status` ['PENDING', 'CONFIRMED', 'CANCELLED'])
9. **`order_items`**: รายการสินค้าในคำสั่งซื้อ (`order_item_id` [PK], `order_id` [FK], `ebook_id` [FK], `quantity`, `unit_price` [Snapshot price])
10. **`payments`**: หลักฐานการชำระเงินจำลอง (`payment_id` [PK], `order_id` [FK, UNIQUE], `payment_method`, `payment_date`, `proof_document_url`, `payment_status` ['PENDING', 'VERIFIED', 'REJECTED'])
11. **`download_links`**: ลิงก์ดาวน์โหลดไฟล์ดิจิทัล (`link_id` [PK], `order_id` [FK], `ebook_id` [FK], `download_url`, `access_token` [UNIQUE], `expiry_date`, `download_count`)

---

### 6. ข้อกำหนดรายงานเชิงวิเคราะห์ 4 รายงาน (SQL Analytical Reports)

#### รายงานที่ 1: สรุปยอดขายตามช่วงเวลา (Sales Over Time)
- **วัตถุประสงค์:** แสดงรายได้รวม จำนวนคำสั่งซื้อ และยอดชำระเฉลี่ยต่อคำสั่งซื้อ จัดกลุ่มตามเดือน
- **SQL Clauses ที่ต้องใช้:** `SELECT`, `JOIN`, `GROUP BY`, `SUM`, `COUNT`, `AVG`, `WHERE`, `ORDER BY`

#### รายงานที่ 2: E-Book ยอดนิยม 5 อันดับแรก (Top 5 Best-Selling E-Books)
- **วัตถุประสงค์:** ค้นหาหนังสือดิจิทัลที่มียอดสั่งซื้อสูงสุด ทั้งจำนวนเล่มและยอดขายรวม
- **SQL Clauses ที่ต้องใช้:** `SELECT`, `INNER JOIN`, `GROUP BY`, `SUM`, `ORDER BY DESC`, `LIMIT 5`

#### รายงานที่ 3: สรุปยอดขายตามหมวดหมู่สินค้า (Sales Performance by Category)
- **วัตถุประสงค์:** เปรียบเทียบความต้องการของตลาดว่าหมวดหมู่ใดสร้างรายได้และมีสัดส่วนยอดขายมากที่สุด
- **SQL Clauses ที่ต้องใช้:** `SELECT`, Multi-table `JOIN`, `GROUP BY`, `SUM`, `COUNT`, `ORDER BY DESC`

#### รายงานที่ 4: พฤติกรรมการซื้อของลูกค้าและการจำแนกสถานะคำสั่งซื้อ (Customer Lifetime Value & Order Status)
- **วัตถุประสงค์:** ค้นหากลุ่มลูกค้า VIP (ยอดซื้อสะสมสูง หรือซื้อมากกว่าจำนวนครั้งที่กำหนด) พร้อมแจกแจงจำนวนออเดอร์ในแต่ละสถานะ
- **SQL Clauses ที่ต้องใช้:** `SELECT`, `JOIN`, `GROUP BY`, `HAVING SUM(...) > X`, `COUNT`, `CASE WHEN`