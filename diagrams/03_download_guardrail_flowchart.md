# 🛡️ ผังงานการตรวจสอบสิทธิ์การเข้าถึงไฟล์ดาวน์โหลด E-Book (Download Guardrail Flowchart)
## ระบบร้านค้า E-Book ออนไลน์ (Bookie House)

เอกสารนี้แสดงผังงานการทำงานของระบบควบคุมและตรวจสอบสิทธิ์หลายชั้น (Multi-layered Access Guardrails) เพื่อป้องกันไม่ให้ผู้ใช้งานหรือบุคคลภายนอกเข้าถึงลิงก์ดาวน์โหลดหนังสือดิจิทัล (E-Book File) โดยไม่ผ่านการชำระเงิน หรือคำสั่งซื้อยังไม่ได้รับการยืนยันสถานะเป็น `confirmed` จากผู้ดูแลระบบ

---

### 1. แผนภาพ Flowchart การตรวจสอบสิทธิ์การดาวน์โหลด

```mermaid
flowchart TD
    %% จุดเริ่มต้น
    Start(["ผู้ใช้ร้องขอดาวน์โหลด E-Book หรือเปิดหน้าประวัติคำสั่งซื้อ"]) --> Guard1{"ด่านที่ 1: ตรวจสอบการเข้าสู่ระบบ<br/>(currentUser != null ?)"}

    %% ด่านที่ 1: การยืนยันตัวตน (Authentication)
    Guard1 -->|"ไม่ได้เข้าสู่ระบบ (Guest)"| DenyGuest["❌ กั้นการเข้าถึงทันที<br/>1. แจ้งเตือน: กรุณาเข้าสู่ระบบก่อน<br/>2. เปิด Auth Modal เพื่อให้ Login"]
    DenyGuest --> EndDenied(["สิ้นสุด / ปฏิเสธคำขอ"])

    Guard1 -->|"เข้าสู่ระบบแล้ว (Member / Admin)"| CheckRole{"ผู้ใช้งานมีบทบาทเป็นอะไร?"}

    %% แยกสาย Admin vs Customer
    CheckRole -->|"Admin (ผู้ดูแลระบบ)"| AdminPass["👑 สิทธิ์ผู้ดูแลระบบ (Admin Bypass)<br/>อนุญาตให้ตรวจสอบและเข้าถึงได้ทั้งหมด"]
    
    CheckRole -->|"Customer (ลูกค้าทั่วไป)"| QueryOrders["ดึงรายการคำสั่งซื้อเฉพาะของตนเอง<br/>(WHERE user_id = currentUser.id)"]

    %% ด่านที่ 2: ความเป็นเจ้าของคำสั่งซื้อ (Ownership Guard)
    QueryOrders --> Guard2{"ด่านที่ 2: ตรวจสอบความเป็นเจ้าของ<br/>(พบคำสั่งซื้อของลูกค้ารายนี้หรือไม่?)"}
    
    Guard2 -->|"ไม่พบคำสั่งซื้อ"| EmptyOrders["แสดงข้อความ: ยังไม่มีรายการคำสั่งซื้อ<br/>(ไม่แสดงรายการและปุ่มใดๆ)"]
    EmptyOrders --> EndEmpty(["สิ้นสุด"])

    Guard2 -->|"พบคำสั่งซื้อ"| ProcessOrder["นำคำสั่งซื้อแต่ละรายการมาประเมินเงื่อนไข"]

    %% ด่านที่ 3: สถานะคำสั่งซื้อ (Order Status Guard)
    ProcessOrder --> Guard3{"ด่านที่ 3: ตรวจสอบสถานะคำสั่งซื้อ<br/>(order.status == 'confirmed' ?)"}

    %% กรณีสถานะเป็น Pending (รอตรวจสอบสลิป)
    Guard3 -->|"สถานะ = pending (รอแอดมินตรวจสลิป)"| BlockPending["🔒 กั้นสิทธิ์การดาวน์โหลด (Pending Guard)<br/>1. แสดงป้ายสถานะ: รอตรวจสอบ (สีส้ม/เหลือง)<br/>2. ซ่อนปุ่มดาวน์โหลด หรือแสดงเครื่องหมาย '-'<br/>3. ไม่ส่งออก URL ไฟล์ E-Book"]
    BlockPending --> NextOrder{"มีคำสั่งซื้อถัดไปในลิสต์หรือไม่?"}

    %% กรณีสถานะเป็น Cancelled (ยกเลิกคำสั่งซื้อ)
    Guard3 -->|"สถานะ = cancelled (ยกเลิกคำสั่งซื้อ)"| BlockCancelled["🚫 กั้นสิทธิ์การดาวน์โหลดถาวร (Cancelled Guard)<br/>1. แสดงป้ายสถานะ: ยกเลิก (สีแดง)<br/>2. ปิดกั้นการดาวน์โหลดอย่างถาวร<br/>3. ไม่อนุญาตให้เปิดสิทธิ์"]
    BlockCancelled --> NextOrder

    %% กรณีสถานะเป็น Confirmed (ผ่านการอนุมัติแล้ว)
    Guard3 -->|"สถานะ = confirmed (ยืนยันแล้ว)"| Guard4{"ด่านที่ 4: ตรวจสอบความพร้อมของไฟล์<br/>(dlUrl != null && is_active == true ?)"}
    
    AdminPass --> Guard4

    %% ด่านที่ 4: ความพร้อมของไฟล์หนังสือ
    Guard4 -->|"ไม่พบไฟล์ หรือหนังสือถูกระงับขาย"| FileError["⚠️ แจ้งเตือนข้อผิดพลาด<br/>ไฟล์หนังสือไม่พร้อมใช้งาน กรุณาติดต่อแอดมิน"]
    FileError --> NextOrder

    Guard4 -->|"ไฟล์และข้อมูลพร้อมสมบูรณ์"| GrantAccess["✅ ปลดล็อกสิทธิ์สำเร็จ (Access Granted)"]
    
    %% การส่งมอบไฟล์
    GrantAccess --> RenderDownloadBtn["เรนเดอร์ปุ่ม: ⬇ ดาวน์โหลด E-Book (.PDF)<br/>พร้อมแนบ URL ปลายทางที่ปลอดภัย"]
    RenderDownloadBtn --> UserDownload["ลูกค้าคลิกปุ่มดาวน์โหลด"]
    UserDownload --> OpenFile(["🎉 ดาวน์โหลดหรือเปิดอ่าน E-Book สำเร็จ"])

    NextOrder -->|"มีรายการถัดไป"| ProcessOrder
    NextOrder -->|"ครบทุกรายการแล้ว"| FinishRender(["เรนเดอร์หน้าจอประวัติคำสั่งซื้อเสร็จสมบูรณ์"])

    %% กำหนดสไตล์ของ Node
    classDef startEnd fill:#FCE7F3,stroke:#DB2777,stroke-width:2px,color:#831843;
    classDef guard fill:#FEF3C7,stroke:#D97706,stroke-width:2px,color:#78350F;
    classDef block fill:#FEE2E2,stroke:#DC2626,stroke-width:2px,color:#7F1D1D;
    classDef success fill:#D1FAE5,stroke:#059669,stroke-width:2px,color:#064E3B;

    class Start,OpenFile,FinishRender startEnd;
    class Guard1,Guard2,Guard3,Guard4,CheckRole guard;
    class DenyGuest,BlockPending,BlockCancelled,FileError block;
    class GrantAccess,RenderDownloadBtn,AdminPass success;
```

---

### 2. หลักการทำงานของ Guardrail 4 ระดับ (Defense-in-Depth)

| ระดับของ Guardrail | ประเภทการตรวจสอบ (Guardrail Type) | รายละเอียดเงื่อนไขการตรวจสอบ (Inspection Criteria) | ผลลัพธ์เมื่อไม่ผ่านเงื่อนไข (Failure Action) |
| :---: | :--- | :--- | :--- |
| **ด่านที่ 1** | **Authentication Guard** | ตรวจสอบว่าผู้ใช้มี Session การเข้าสู่ระบบที่ถูกต้อง (`currentUser != null`) | บล็อกการเข้าถึงหน้า Orders, ส่งไปยัง Auth Modal บังคับให้ล็อกอินก่อน |
| **ด่านที่ 2** | **Ownership & Tenant Isolation** | กรองเฉพาะคำสั่งซื้อที่เป็นของตนเองเท่านั้น (`user_id == currentUser.id`) | ป้องกัน IDOR (Insecure Direct Object Reference) ลูกค้าไม่สามารถดูออเดอร์ของผู้อื่นได้ |
| **ด่านที่ 3** | **Financial & Order Status Guard** | ตรวจสอบว่า `order.status` ต้องมีค่าเป็น **`'confirmed'`** เท่านั้น | หากเป็น `pending` หรือ `cancelled` ระบบจะซ่อนปุ่มดาวน์โหลดและไม่ปล่อย URL ไฟล์ออกมา |
| **ด่านที่ 4** | **Asset Integrity Guard** | ตรวจสอบว่าหนังสือเล่มดังกล่าวยังเปิดจำหน่าย (`is_active = true`) และมี URL ดาวน์โหลดที่ถูกต้อง | ป้องกันการเกิด Broken Link หรือไฟล์ที่ถูกยกเลิกการเผยแพร่ |

---

### 3. การแมปกับการทำงานในโค้ดจริง (`index.html`)

ในฟังก์ชัน `renderCustomerOrders()` ของระบบ มีการใช้ Guardrail นี้อย่างเคร่งครัด:

```javascript
// ตรวจสอบสิทธิ์การแสดงผลปุ่มดาวน์โหลดตามสถานะคำสั่งซื้อ (Guardrail Implementation)
let action = o.status === 'confirmed'
  ? `<a href="${o.dlUrl}" target="_blank" class="bg-gradient-to-r from-glam-rose to-glam-roseDark text-white text-xs px-3.5 py-2 rounded-xl font-bold shadow inline-block">⬇ ดาวน์โหลด</a>`
  : '<span class="text-xs text-stone-400 italic">-</span>';
```

- หาก `o.status === 'pending'` $\rightarrow$ แสดงเครื่องหมาย `-` (ไม่อนุญาตให้ดาวน์โหลด)
- หาก `o.status === 'cancelled'` $\rightarrow$ แสดงเครื่องหมาย `-` (ไม่อนุญาตให้ดาวน์โหลด)
- หาก `o.status === 'confirmed'` $\rightarrow$ เรนเดอร์ปุ่มดาวน์โหลดพร้อมลิงก์ไฟล์ PDF จริง
