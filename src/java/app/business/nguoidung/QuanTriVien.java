package app.business.nguoidung;

import javax.persistence.*;

@Entity
@Table(name = "QuanTriVien")
// =================================================================
// KHAI BÁO GIÁ TRỊ PHÂN BIỆT
// =================================================================
@DiscriminatorValue("QuanTriVien")
// =================================================================
public class QuanTriVien extends User {
    // Thêm các thuộc tính riêng của quản trị viên ở đây nếu cần
}