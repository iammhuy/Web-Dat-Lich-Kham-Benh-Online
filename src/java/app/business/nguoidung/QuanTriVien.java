package app.business.nguoidung;

import javax.persistence.*;

@Entity
@Table(name = "QuanTriVien")
@PrimaryKeyJoinColumn(name = "userId")
public class QuanTriVien extends User {
    // thêm các phương thức/thuộc tính admin nếu cần
    // ví dụ: quyền nâng cao, ghi nhật ký, ...
}
