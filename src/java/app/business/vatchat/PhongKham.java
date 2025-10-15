package app.business.vatchat;

import java.io.Serializable;
import javax.persistence.*;

@Entity
@Table(name = "PhongKham")
public class PhongKham implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "PHONG_ID")
    private Integer phongId;

    @Column(name = "TEN_PHONG", length = 200, nullable = false)
    private String tenPhong;

    // ===============================
    // LIÊN KẾT TỚI KHOA (nhiều phòng -> 1 khoa)
    // ===============================
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(
        name = "ID_KHOA",                    // tên cột khóa ngoại trong bảng PhongKham
        referencedColumnName = "ID",         // cột được tham chiếu trong bảng Khoa
        nullable = false,
        foreignKey = @ForeignKey(name = "FK_PHONGKHAM_KHOA")
    )
    private Khoa khoa;

    // ===============================
    // Constructors
    // ===============================
    public PhongKham() {}

    // ===============================
    // Getters & Setters
    // ===============================
    public Integer getPhongId() {
        return phongId;
    }

    public void setPhongId(Integer phongId) {
        this.phongId = phongId;
    }

    public String getTenPhong() {
        return tenPhong;
    }

    public void setTenPhong(String tenPhong) {
        this.tenPhong = tenPhong;
    }

    public Khoa getKhoa() {
        return khoa;
    }

    public void setKhoa(Khoa khoa) {
        this.khoa = khoa;
    }
}
