package app.business.nguoidung;

import javax.persistence.*;
import app.business.vatchat.Khoa; // nếu bạn có package này

@Entity
@Table(name = "BacSi")
@PrimaryKeyJoinColumn(name = "userId")
public class BacSi extends User {

    @Column
    private Integer bangCap;

    @Column(length = 150)
    private String chuyenNganh;

    @Column
    private Integer kinhNghiem; // số năm

    @ManyToOne
    @JoinColumn(name = "khoaId")
    private Khoa khoa; // nếu bạn đã có entity Khoa

    // getters / setters
    public Integer getBangCap() { return bangCap; }
    public void setBangCap(Integer bangCap) { this.bangCap = bangCap; }

    public String getChuyenNganh() { return chuyenNganh; }
    public void setChuyenNganh(String chuyenNganh) { this.chuyenNganh = chuyenNganh; }

    public Integer getKinhNghiem() { return kinhNghiem; }
    public void setKinhNghiem(Integer kinhNghiem) { this.kinhNghiem = kinhNghiem; }

    public Khoa getKhoa() { return khoa; }
    public void setKhoa(Khoa khoa) { this.khoa = khoa; }
}
