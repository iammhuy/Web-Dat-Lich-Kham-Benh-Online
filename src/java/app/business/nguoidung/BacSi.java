package app.business.nguoidung;

import app.business.vatchat.Khoa;
import java.io.Serializable;
import javax.persistence.*;

@Entity
@Table(name = "BacSi") // Sửa lại tên bảng
// =================================================================
// KHAI BÁO GIÁ TRỊ PHÂN BIỆT
// =================================================================
@DiscriminatorValue("BacSi")
// =================================================================
public class BacSi extends User implements Serializable {

    @Column(name = "CHUYENNGANH")
    private String chuyenNganh;

    @Column(name = "BANGCAP")
    private String bangCap; // Đổi sang String để linh hoạt

    @Column(name = "KINHNGHIEM")
    private Integer kinhNghiem;
    
    @Column(name = "chi_phi_kham")
    private double chiPhiKham;

    @ManyToOne
    @JoinColumn(name = "khoaId") // Tên cột khóa ngoại
    private Khoa khoa;

    // Getters and Setters
    public String getChuyenNganh() {
        return chuyenNganh;
    }

    public void setChuyenNganh(String chuyenNganh) {
        this.chuyenNganh = chuyenNganh;
    }

    public String getBangCap() {
        return bangCap;
    }

    public void setBangCap(String bangCap) {
        this.bangCap = bangCap;
    }

    public Integer getKinhNghiem() {
        return kinhNghiem;
    }

    public void setKinhNghiem(Integer kinhNghiem) {
        this.kinhNghiem = kinhNghiem;
    }

    public double getChiPhiKham() {
        return chiPhiKham;
    }

    public void setChiPhiKham(double chiPhiKham) {
        this.chiPhiKham = chiPhiKham;
    }
    
    public Khoa getKhoa() {
        return khoa;
    }

    public void setKhoa(Khoa khoa) {
        this.khoa = khoa;
    }
}