package app.business.giaodich;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

// Chú thích quan trọng nhất: báo cho JPA biết đây là một Entity
@Entity
// Ánh xạ lớp này đến bảng có tên là "ThanhToan"
@Table(name = "ThanhToan")
public class ThanhToan implements Serializable {

    @Id // Đánh dấu đây là khóa chính
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Khóa chính tự động tăng
    private int thanhToanId;

    // Ánh xạ đến cột có tên là "lichHenId", không được null
    @Column(name = "lichHenId", nullable = false)
    private int lichHenId;

    @Column(name = "soTien", nullable = false)
    private BigDecimal soTien;

    // Chú thích đặc biệt cho kiểu Enum, lưu tên của Enum (SUCCESS, PENDING) vào CSDL
    @Enumerated(EnumType.STRING)
    @Column(name = "phuongThuc")
    private PhuongThuc phuongThuc;

    @Enumerated(EnumType.STRING)
    @Column(name = "trangThai")
    private TrangThai trangThai;

    @Column(name = "ngayThanhToan")
    private LocalDateTime ngayThanhToan;

    @Column(name = "maGiaoDichVnpay")
    private String maGiaoDichVnpay;

    // --- Getters and Setters (Giữ nguyên) ---
    public int getThanhToanId() {
        return thanhToanId;
    }

    public void setThanhToanId(int thanhToanId) {
        this.thanhToanId = thanhToanId;
    }

    public int getLichHenId() {
        return lichHenId;
    }

    public void setLichHenId(int lichHenId) {
        this.lichHenId = lichHenId;
    }

    public BigDecimal getSoTien() {
        return soTien;
    }

    public void setSoTien(BigDecimal soTien) {
        this.soTien = soTien;
    }

    public PhuongThuc getPhuongThuc() {
        return phuongThuc;
    }

    public void setPhuongThuc(PhuongThuc phuongThuc) {
        this.phuongThuc = phuongThuc;
    }

    public TrangThai getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(TrangThai trangThai) {
        this.trangThai = trangThai;
    }

    public LocalDateTime getNgayThanhToan() {
        return ngayThanhToan;
    }

    public void setNgayThanhToan(LocalDateTime ngayThanhToan) {
        this.ngayThanhToan = ngayThanhToan;
    }

    public String getMaGiaoDichVnpay() {
        return maGiaoDichVnpay;
    }

    public void setMaGiaoDichVnpay(String maGiaoDichVnpay) {
        this.maGiaoDichVnpay = maGiaoDichVnpay;
    }
}
