# 🔄 ลำดับขั้นตอนธุรกรรมการสั่งซื้อและชำระเงิน (Checkout Transaction Sequence Diagram)
## ระบบร้านค้า E-Book ออนไลน์ (Bookie House)

เอกสารนี้แสดงลำดับขั้นตอนการทำงาน (Sequence of Events) ตั้งแต่ลูกค้าเริ่มกดทำรายการสั่งซื้อ (Checkout) จากตะกร้าสินค้า การบันทึกข้อมูลธุรกรรมแบบหลายตาราง (Multi-table Transaction: `orders`, `order_items`, `payments`) การแจ้งเตือนแบบ Real-time จนถึงขั้นตอนที่ผู้ดูแลระบบตรวจสอบหลักฐานและอนุมัติคำสั่งซื้อ

---

### 1. แผนภาพ Sequence Diagram

```mermaid
sequenceDiagram
    autonumber
    actor Customer as 👤 ลูกค้า (Customer)
    participant UI as 🖥️ เว็บแอปพลิเคชัน (Frontend UI)
    participant API as ⚡ Supabase Client (API Layer)
    participant DB_Orders as 🗄️ ตาราง orders
    participant DB_Items as 🗄️ ตาราง order_items
    participant DB_Payments as 🗄️ ตาราง payments
    participant Realtime as 📡 Postgres Realtime Engine
    actor Admin as 👑 ผู้ดูแลระบบ (Admin)

    %% 1. เริ่มต้นกระบวนการสั่งซื้อ
    Note over Customer, UI: 1. ตรวจสอบตะกร้าและเตรียมชำระเงิน
    Customer ->> UI: กดเปิดตะกร้าสินค้า (View Cart)
    UI -->> Customer: แสดงรายการ E-Book, จำนวน, และยอดรวมสุทธิ (Total Amount)
    Customer ->> UI: กดปุ่ม "ยืนยันสั่งซื้อสินค้า" (Proceed to Checkout)

    %% 2. ตรวจสอบสิทธิ์ผู้ใช้
    alt ผู้ใช้ยังไม่ได้เข้าสู่ระบบ (!currentUser)
        UI -->> Customer: แจ้งเตือน "กรุณาเข้าสู่ระบบก่อนสั่งซื้อ" และเปิด Auth Modal
    else ผู้ใช้เข้าสู่ระบบแล้ว (Member / Customer)
        UI ->> UI: แสดงหน้าต่างชำระเงิน (QR Code พร้อมเพย์ / บัญชีธนาคาร)
        Customer ->> UI: เลือกช่องทางชำระเงิน และอัปโหลดสลิปโอนเงิน (Upload Slip)
        Customer ->> UI: กดปุ่ม "ยืนยันและส่งหลักฐานการโอน" (confirmOrderWithSlip)

        %% 3. กระบวนการบันทึกข้อมูลลงฐานข้อมูล (Data Persistence)
        Note over UI, DB_Payments: 2. บันทึกข้อมูลลงฐานข้อมูล (3 ตารางต่อเนื่อง)
        UI ->> UI: คำนวณ nextOrderId และบันทึก Snapshot Timestamp (nowIso)

        %% 3.1 บันทึกตาราง orders
        UI ->> API: INSERT orders (order_id, user_id, total_amount, order_status: 'pending')
        API ->> DB_Orders: บันทึกข้อมูลใบสั่งซื้อใหม่
        DB_Orders -->> API: ยืนยันการสร้าง Order สำเร็จ (HTTP 201 Created)
        API -->> UI: ส่งคืน Order Record ที่สร้างสำเร็จ

        %% 3.2 บันทึกตาราง order_items
        UI ->> API: INSERT order_items (order_id, ebook_id, quantity, price_per_unit)
        API ->> DB_Items: บันทึกรายการหนังสือทุกเล่มในตะกร้า (Snapshot Price)
        DB_Items -->> API: ยืนยันการบันทึก Order Items สำเร็จ
        API -->> UI: ส่งคืนผลการบันทึกรายการสินค้า

        %% 3.3 บันทึกตาราง payments
        UI ->> API: INSERT payments (order_id, payment_method, slip_image_url, is_verified: false)
        API ->> DB_Payments: บันทึกประวัติและหลักฐานการโอนเงินจำลอง
        DB_Payments -->> API: ยืนยันการบันทึก Payment สำเร็จ
        API -->> UI: ส่งคืนผลการบันทึกข้อมูลการชำระเงิน

        %% 4. แจ้งเตือนผ่าน Realtime WebSocket
        Note over DB_Orders, Realtime: 3. การกระจาย Event สู่ผู้ใช้งานแบบ Real-time
        DB_Orders ->> Realtime: Trigger Event: INSERT on orders
        Realtime -->> Admin: Broadcast: คำสั่งซื้อใหม่ #ORD-XXX (สถานะ pending)
        Realtime -->> UI: Broadcast: ปรับปรุงข้อมูลคำสั่งซื้อในระบบ

        %% 5. ตอบสนองฝั่งลูกค้า
        UI ->> UI: เคลียร์ตะกร้าสินค้า (cart = []), รีเซ็ต Cart Badge เป็น 0
        UI -->> Customer: แจ้งเตือน "สั่งซื้อสำเร็จ! รอเจ้าหน้าที่ตรวจสอบสลิป"
        UI ->> UI: นำทางไปยังหน้า "ประวัติคำสั่งซื้อ" (Orders View)
        UI -->> Customer: แสดงคำสั่งซื้อล่าสุด พร้อมป้ายกำกับ "รอตรวจสอบ (Pending)" [ยังไม่แสดงปุ่มดาวน์โหลด]

        %% 6. แอดมินตรวจสอบและยืนยันคำสั่งซื้อ
        Note over Admin, Customer: 4. การตรวจสอบสลิปและปลดล็อกการดาวน์โหลด
        Admin ->> UI: เปิดแท็บคำสั่งซื้อหลังบ้าน (Admin Orders Dashboard)
        Admin ->> UI: กดดูภาพสลิปหลักฐานโอนเงิน (Inspect Slip Modal)
        UI -->> Admin: แสดงรูปภาพสลิป, ยอดเงินที่ต้องชำระ, วันเวลาโอน
        
        alt แอดมินกดยืนยันการชำระเงิน (Confirm Order)
            Admin ->> UI: กดปุ่ม "อนุมัติการชำระเงิน" (Confirm Order)
            UI ->> API: UPDATE orders SET order_status = 'confirmed' WHERE order_id = target_id
            API ->> DB_Orders: อัปเดตสถานะเป็น confirmed
            DB_Orders -->> API: อัปเดตสำเร็จ
            DB_Orders ->> Realtime: Trigger Event: UPDATE on orders
            Realtime -->> UI: อัปเดตข้อมูลบนหน้าจอของลูกค้าทันที
            UI -->> Customer: สถานะเปลี่ยนเป็น "ยืนยันแล้ว (Confirmed)" และแสดงปุ่ม "⬇ ดาวน์โหลด E-Book" ทันที
        else แอดมินตรวจสอบแล้วพบข้อผิดพลาด / สลิปไม่ถูกต้อง (Cancel Order)
            Admin ->> UI: กดปุ่ม "ยกเลิกคำสั่งซื้อ" (Cancel Order)
            UI ->> API: UPDATE orders SET order_status = 'cancelled' WHERE order_id = target_id
            API ->> DB_Orders: อัปเดตสถานะเป็น cancelled
            Realtime -->> UI: อัปเดตสถานะบนหน้าจอลูกค้าเป็น "ยกเลิก (Cancelled)"
        end
    end
```

---

### 2. คำอธิบายขั้นตอนสำคัญในกระบวนการทำงาน

| ลำดับที่ | ขั้นตอนหลัก (Process Phase) | กิจกรรมที่เกิดขึ้นในระบบ (System Activities) | การรับประกันความปลอดภัยและความถูกต้อง (Integrity & Guardrails) |
| :---: | :--- | :--- | :--- |
| **1 - 4** | **Cart & Checkout Validation** | ตรวจสอบตะกร้าสินค้า ยอดเงินรวม และตรวจสอบว่าผู้ใช้ได้เข้าสู่ระบบ (`currentUser`) หรือไม่ | ป้องกัน Guest สั่งซื้อ และป้องกันการสั่งซื้อขณะตะกร้าว่างเปล่า |
| **5 - 7** | **Simulated Payment Capture** | แสดงช่องทางชำระเงินจำลอง (QR / Bank Transfer) และให้แนบไฟล์สลิป | ไม่มีการขอข้อมูลบัตรเครดิตหรือข้อมูลทางการเงินจริง (Zero Financial Risk) |
| **8 - 11** | **Database Transaction Execution** | ส่งคำสั่งบันทึกลง 3 ตารางหลักตามลำดับความสัมพันธ์: <br>1. สร้าง Header ใน `orders`<br>2. สร้าง Lines ใน `order_items`<br>3. สร้าง Payment Record ใน `payments` | จัดเก็บ Snapshot Unit Price ป้องกันปัญหาราคาเปลี่ยนในอนาคต และตั้งสถานะเริ่มต้นเป็น `pending` เสมอ |
| **12 - 14** | **Real-time Event & State Reset** | Realtime Engine ส่งสัญญาณอัปเดตข้อมูลสู่ทุก Client, เคลียร์ตะกร้าในเครื่องลูกค้า และนำทางไปหน้าประวัติคำสั่งซื้อ | ข้อมูลออเดอร์ใหม่ปรากฏบนหน้าจอแอดมินทันทีโดยไม่ต้อง Refresh หน้าเว็บ |
| **15 - 19** | **Admin Verification & Order Settlement** | แอดมินตรวจสอบความถูกต้องของสลิป และปรับสถานะเป็น `confirmed` หรือ `cancelled` | ลิงก์ดาวน์โหลดจะยังถูกกั้นไว้ตลอดเวลาตราบใดที่สถานะยังไม่เป็น `confirmed` |
