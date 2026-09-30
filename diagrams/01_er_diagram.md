# 📊 ผังความสัมพันธ์ฐานข้อมูล (Entity-Relationship Diagram: ERD)
## ระบบร้านค้า E-Book ออนไลน์ (Bookie House)

เอกสารนี้แสดงโครงสร้างฐานข้อมูล 8 ตารางหลักของระบบร้านค้า E-Book ออนไลน์ ออกแบบตามหลักการออกแบบฐานข้อมูลเชิงสัมพันธ์ระดับ **Third Normal Form (3NF)** พร้อมระบุ Primary Key (PK), Foreign Key (FK), Constraints และความสัมพันธ์ของข้อมูล (Cardinality) ไว้อย่างครบถ้วน

---

### 1. แผนภาพ ER Diagram (8 ตารางหลัก)

```mermaid
erDiagram
    ROLES ||--o{ USERS : "has (1:N)"
    USERS ||--o{ ORDERS : "places (1:N)"
    CATEGORIES ||--o{ EBOOKS : "classifies (1:N)"
    AUTHORS ||--o{ EBOOKS : "writes (1:N)"
    ORDERS ||--|{ ORDER_ITEMS : "contains (1:N)"
    EBOOKS ||--o{ ORDER_ITEMS : "included_in (1:N)"
    ORDERS ||--|| PAYMENTS : "paid_via (1:1)"

    ROLES {
        int role_id PK "รหัสบทบาท (Auto Increment)"
        string role_name "ชื่อบทบาท เช่น admin, customer [UNIQUE]"
    }

    USERS {
        int user_id PK "รหัสผู้ใช้งาน (Auto Increment)"
        int role_id FK "รหัสบทบาท อ้างอิง ROLES(role_id)"
        string username "ชื่อบัญชีผู้ใช้งาน [UNIQUE]"
        string email "อีเมลติดต่อ [UNIQUE]"
        string password_hash "รหัสผ่านที่ผ่านการแฮช"
        string full_name "ชื่อ-นามสกุลจริง"
        datetime created_at "วันเวลาที่ลงทะเบียน"
    }

    CATEGORIES {
        int category_id PK "รหัสหมวดหมู่ (Auto Increment)"
        string category_name "ชื่อหมวดหมู่ E-Book [UNIQUE]"
        text description "คำอธิบายรายละเอียดหมวดหมู่"
    }

    AUTHORS {
        int author_id PK "รหัสนักเขียน/ผู้แต่ง (Auto Increment)"
        string author_name "ชื่อ-นามสกุล หรือนามปากกา"
        text bio "ประวัติและผลงานย่อของนักเขียน"
    }

    EBOOKS {
        int ebook_id PK "รหัสหนังสือดิจิทัล (Auto Increment)"
        int author_id FK "รหัสนักเขียน อ้างอิง AUTHORS(author_id)"
        int category_id FK "รหัสหมวดหมู่ อ้างอิง CATEGORIES(category_id)"
        string title "ชื่อเรื่อง E-Book"
        decimal price "ราคาขาย [CHECK price >= 0]"
        text description "เรื่องย่อและคำอธิบายเนื้อหา"
        string cover_image_url "ลิงก์รูปภาพหน้าปกหนังสือ"
        string file_download_url "ลิงก์ที่จัดเก็บไฟล์ดาวน์โหลด (.pdf)"
        boolean is_active "สถานะเปิด/ปิดการจำหน่าย"
        datetime created_at "วันเวลาที่เพิ่มหนังสือเข้าระบบ"
    }

    ORDERS {
        int order_id PK "รหัสคำสั่งซื้อ (Auto Increment)"
        int user_id FK "รหัสลูกค้า อ้างอิง USERS(user_id)"
        decimal total_amount "ยอดเงินรวมสุทธิ [CHECK total_amount >= 0]"
        string status "สถานะคำสั่งซื้อ (pending, confirmed, cancelled)"
        datetime order_datetime "วันเวลาที่ทำรายการสั่งซื้อ"
    }

    ORDER_ITEMS {
        int order_item_id PK "รหัสรายการในคำสั่งซื้อ (Auto Increment)"
        int order_id FK "รหัสคำสั่งซื้อ อ้างอิง ORDERS(order_id)"
        int ebook_id FK "รหัสหนังสือ อ้างอิง EBOOKS(ebook_id)"
        int quantity "จำนวนที่สั่งซื้อ [CHECK quantity > 0]"
        decimal unit_price "ราคาต่อหน่วย ณ เวลาสั่งซื้อ (Snapshot Price)"
        decimal subtotal "ยอดรวมย่อยของรายการ (quantity * unit_price)"
    }

    PAYMENTS {
        int payment_id PK "รหัสรายการชำระเงิน (Auto Increment)"
        int order_id FK "รหัสคำสั่งซื้อ อ้างอิง ORDERS(order_id) [UNIQUE]"
        string payment_method "ช่องทางชำระเงิน (พร้อมเพย์ QR, โอนผ่านธนาคาร)"
        decimal amount_paid "ยอดเงินที่แจ้งชำระ [CHECK amount_paid >= 0]"
        string slip_image_url "ลิงก์ไฟล์รูปภาพสลิปหลักฐานการโอน"
        string payment_status "สถานะการตรวจสอบ (pending, verified, rejected)"
        datetime payment_datetime "วันเวลาที่แจ้งชำระเงิน"
    }
```

---

### 2. ตารางสรุปความสัมพันธ์ของข้อมูล (Entity Relationships & Cardinality)

| ความสัมพันธ์ (Relationship) | ความสัมพันธ์แบบ (Cardinality) | คำอธิบายความสัมพันธ์เชิงธุรกิจ | Foreign Key Constraint |
| :--- | :---: | :--- | :--- |
| **ROLES $\rightarrow$ USERS** | `1 : N` | บทบาท 1 บทบาท สามารถกำหนดให้กับผู้ใช้ได้หลายคน แต่ผู้ใช้ 1 คนมีได้ 1 บทบาทหลัก | `ON DELETE RESTRICT` ป้องกันการลบบทบาทที่มีผู้ใช้อยู่ |
| **USERS $\rightarrow$ ORDERS** | `1 : N` | ลูกค้า 1 คน สามารถสร้างคำสั่งซื้อได้หลายครั้ง แต่ละคำสั่งซื้อต้องผูกกับลูกค้า 1 คน | `ON DELETE RESTRICT` ป้องกันการลบบัญชีผู้ใช้ที่มีประวัติคำสั่งซื้อ |
| **CATEGORIES $\rightarrow$ EBOOKS** | `1 : N` | หมวดหมู่ 1 หมวดหมู่ บรรจุ E-Book ได้หลายเล่ม แต่ละเล่มสังกัดหมวดหมู่หลัก 1 หมวดหมู่ | `ON DELETE RESTRICT` ป้องกันการลบหมวดหมู่ที่มีหนังสืออยู่ |
| **AUTHORS $\rightarrow$ EBOOKS** | `1 : N` | นักเขียน 1 คน สามารถแต่งหนังสือได้หลายเล่ม โดยหนังสือแต่ละเล่มอ้างอิงผู้แต่งหลัก | `ON DELETE RESTRICT` ป้องกันการลบประวัตินักเขียนที่มีผลงานในระบบ |
| **ORDERS $\rightarrow$ ORDER_ITEMS** | `1 : N` | คำสั่งซื้อ 1 รายการ ต้องมีรายการย่อยของหนังสืออย่างน้อย 1 รายการ | `ON DELETE CASCADE` หากคำสั่งซื้อถูกลบ รายการย่อยจะถูกลบตาม |
| **EBOOKS $\rightarrow$ ORDER_ITEMS** | `1 : N` | หนังสือ 1 เล่ม สามารถปรากฏในรายการสั่งซื้อของลูกค้าได้หลายคำสั่งซื้อ | `ON DELETE RESTRICT` ห้ามลบหนังสือที่มีการสั่งซื้อไปแล้ว |
| **ORDERS $\rightarrow$ PAYMENTS** | `1 : 1` | คำสั่งซื้อ 1 รายการ มีหลักฐานการชำระเงินจำลองผูกติดได้เพียง 1 รายการ (`UNIQUE`) | `ON DELETE CASCADE` ลบข้อมูลการชำระเงินตามคำสั่งซื้อ |

---

### 3. จุดเด่นการออกแบบตามหลัก 3NF และความปลอดภัยของข้อมูล

1. **Snapshot Pricing ในตาราง `ORDER_ITEMS`**:
   - บันทึกคอลัมน์ `unit_price` ณ ขณะทำการสั่งซื้อ เพื่อป้องกันปัญหาราคาประวัติศาสตร์เปลี่ยนแปลงเมื่อ Admin มีการปรับราคาขาย E-Book ในตาราง `EBOOKS` ในภายหลัง
2. **การแยก `AUTHORS` และ `CATEGORIES` ออกจาก `EBOOKS`**:
   - ป้องกันการเกิด Redundant Data และ Transitive Dependency (2NF/3NF) ทำให้การอัปเดตชื่อผู้แต่งหรือชื่อหมวดหมู่ทำได้ที่จุดเดียว
3. **การบังคับใช้ Business Constraints**:
   - ราคาและยอดเงินต้องไม่ติดลบ (`CHECK price >= 0`, `CHECK total_amount >= 0`, `CHECK amount_paid >= 0`)
   - จำนวนสินค้าต้องเป็นบวกเสมอ (`CHECK quantity > 0`)
   - ข้อมูลระบุตัวตนสำคัญห้ามซ้ำ (`UNIQUE` บน `username`, `email`, `category_name`, `role_name`, และ `order_id` ใน `PAYMENTS`)
