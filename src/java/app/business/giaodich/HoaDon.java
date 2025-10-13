/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package app.business.giaodich;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import javax.persistence.*;
@Entity
@Table(name = "HoaDon")
public class HoaDon implements Serializable {

    @Id // Đánh dấu đây là khóa chính
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Khóa chính tự động tăng
    private int hoaDonId;

    // Định nghĩa mối quan hệ 1-1: Một Hóa Đơn chỉ thuộc về một Thanh Toán
    // @JoinColumn chỉ định cột khóa ngoại trong bảng HoaDon
    @OneToOne
    @JoinColumn(name = "thanhToanId", nullable = false)
    private ThanhToan thanhToan;

    @Column(name = "noiDung")
    private String noiDung;

    @Column(name = "ngayXuat")
    private LocalDateTime ngayXuat;

    @Column(name = "soTien")
    private BigDecimal soTien;

    // --- Getters và Setters (Giữ nguyên) ---
    public int getHoaDonId() {
        return hoaDonId;
    }

    public void setHoaDonId(int hoaDonId) {
        this.hoaDonId = hoaDonId;
    }

    public ThanhToan getThanhToan() {
        return thanhToan;
    }

    public void setThanhToan(ThanhToan thanhToan) {
        this.thanhToan = thanhToan;
    }

    public String getNoiDung() {
        return noiDung;
    }

    public void setNoiDung(String noiDung) {
        this.noiDung = noiDung;
    }

    public LocalDateTime getNgayXuat() {
        return ngayXuat;
    }

    public void setNgayXuat(LocalDateTime ngayXuat) {
        this.ngayXuat = ngayXuat;
    }

    public BigDecimal getSoTien() {
        return soTien;
    }

    public void setSoTien(BigDecimal soTien) {
        this.soTien = soTien;
    }
}
