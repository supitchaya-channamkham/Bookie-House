# ข้อกำหนดระบบ (System Specification)
## โครงงาน Mini Project: ร้านขาย E-Book ออนไลน์ "Bookie House"

---

### 1. วัตถุประสงค์และขอบเขตของระบบ (System Scope)
ระบบร้านขาย E-Book "Bookie House" พัฒนาขึ้นเพื่อจำลองกระบวนการสั่งซื้อหนังสือดิจิทัลอย่างครบวงจร ประกอบด้วย:
- **ส่วนลูกค้า (Customer):** ค้นหาหนังสือ กรองตามหมวดหมู่ จัดการตะกร้าสินค้า ชำระเงินจำลอง และเข้าถึงลิงก์ดาวน์โหลดหนังสือเฉพาะคำสั่งซื้อที่ได้รับการยืนยันแล้ว
- **ส่วนผู้ดูแลระบบ (Admin):** ตรวจสอบยอดขายผ่าน Dashboard ตรวจสอบหลักฐานจำลองและเปลี่ยนสถานะคำสั่งซื้อ และดูรายงานวิเคราะห์เชิงลึก

---

### 2. โครงสร้างฐานข้อมูล (Database Schema - 3NF)
ฐานข้อมูลประกอบด้วย 11 ตารางตามมาตรฐาน Third Normal Form (3NF):

1. **roles** — บทบาทผู้ใช้งาน (`role_id`, `role_name`)
2. **users** — ข้อมูลผู้ใช้งาน (`user_id`, `role_id`, `username`, `email`, `password_hash`, `full_name`, `created_at`)
3. **categories** — หมวดหมู่หนังสือ (`category_id`, `category_name`, `description`)
4. **authors** — ข้อมูลนักเขียน (`author_id`, `author_name`, `bio`)
5. **ebooks** — ข้อมูลหนังสือดิจิทัล (`ebook_id`, `title`, `author_id`, `category_id`, `price`, `description`, `cover_image_url`, `file_download_url`, `is_active`, `created_at`)
6. **carts** — ตะกร้าสินค้าของผู้ใช้ (`cart_id`, `user_id`, `updated_at`)
7. **cart_items** — รายการสินค้าในตะกร้า (`cart_item_id`, `cart_id`, `ebook_id`, `quantity`, `added_at`)
8. **orders** — คำสั่งซื้อ (`order_id`, `user_id`, `total_amount`, `status`, `order_date`)
9. **order_items** — รายละเอียดสินค้าในคำสั่งซื้อ (`order_item_id`, `order_id`, `ebook_id`, `quantity`, `unit_price`, `subtotal`)
10. **payments** — ข้อมูลการชำระเงินจำลอง (`payment_id`, `order_id`, `payment_method`, `amount_paid`, `slip_image_url`, `payment_status`, `payment_date`)
11. **download_links** — สิทธิ์และลิงก์ดาวน์โหลด (`link_id`, `order_item_id`, `user_id`, `ebook_id`, `access_token`, `download_url`, `expires_at`, `download_count`, `created_at`)

---

### 3. ข้อกำหนดความปลอดภัยและความถูกต้องของข้อมูล (Integrity Constraints)
- **Primary & Foreign Keys:** ทุกตารางมี Primary Key และเชื่อมโยงความสัมพันธ์ด้วย Foreign Key อย่างถูกต้อง
- **CHECK Constraints:** 
  - ราคาหนังสือ (`ebooks.price >= 0.00`)
  - จำนวนสินค้าในตะกร้าและออเดอร์ (`quantity > 0`)
  - ยอดรวมคำสั่งซื้อและการชำระเงิน (`total_amount >= 0.00`, `amount_paid >= 0.00`)
- **UNIQUE Constraints:** อีเมลและชื่อผู้ใช้ห้ามซ้ำ (`users.username`, `users.email`)
- **Access Rule:** ระบบจะไม่อนุญาตให้เปิดลิงก์ดาวน์โหลด หากคำสั่งซื้อยังไม่เปลี่ยนสถานะเป็น `confirmed`

erDiagram
    ROLES ||--o{ USERS : "has"
    USERS ||--|| CARTS : "owns"
    USERS ||--o{ ORDERS : "places"
    USERS ||--o{ DOWNLOAD_LINKS : "owns"
    
    CATEGORIES ||--o{ EBOOKS : "classifies"
    AUTHORS ||--o{ EBOOKS : "writes"
    
    CARTS ||--o{ CART_ITEMS : "contains"
    EBOOKS ||--o{ CART_ITEMS : "added_to"
    
    ORDERS ||--o{ ORDER_ITEMS : "contains"
    EBOOKS ||--o{ ORDER_ITEMS : "ordered_in"
    
    ORDERS ||--|| PAYMENTS : "paid_by"
    ORDER_ITEMS ||--|| DOWNLOAD_LINKS : "grants"

    ROLES {
        int role_id PK
        string role_name UK
    }
    USERS {
        int user_id PK
        int role_id FK
        string username UK
        string email UK
        string password_hash
        string full_name
    }
    CATEGORIES {
        int category_id PK
        string category_name UK
    }
    AUTHORS {
        int author_id PK
        string author_name
    }
    EBOOKS {
        int ebook_id PK
        string title
        int author_id FK
        int category_id FK
        decimal price
        boolean is_active
    }
    CARTS {
        int cart_id PK
        int user_id FK
    }
    CART_ITEMS {
        int cart_item_id PK
        int cart_id FK
        int ebook_id FK
        int quantity
    }
    ORDERS {
        int order_id PK
        int user_id FK
        decimal total_amount
        string status
    }
    ORDER_ITEMS {
        int order_item_id PK
        int order_id FK
        int ebook_id FK
        int quantity
        decimal unit_price
        decimal subtotal
    }
    PAYMENTS {
        int payment_id PK
        int order_id FK
        string payment_method
        decimal amount_paid
        string payment_status
    }
    DOWNLOAD_LINKS {
        int link_id PK
        int order_item_id FK
        int user_id FK
        int ebook_id FK
        string access_token UK
        string download_url
    }