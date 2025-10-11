package app.business.nguoidung;

import javax.persistence.*;
import app.business.vatchat.Khoa;

@Entity
@Table(name = "BacSi")
public class BacSi extends User {

    private String chuyenNganh;

    private Integer bangCap;

    private Integer kinhNghiem;

    //@Transient
    //private String phong;  // Bỏ ánh xạ trường này vì DB không có cột này

    //private Integer soBenhNhanNgay;

    @ManyToOne
    @JoinColumn(name = "khoaId")
    private Khoa khoa;

    // Getters & setters
    public String getChuyenNganh() {
        return chuyenNganh;
    }

    public void setChuyenNganh(String chuyenNganh) {
        this.chuyenNganh = chuyenNganh;
    }

    public Integer getBangCap() {
        return bangCap;
    }

    public void setBangCap(Integer bangCap) {
        this.bangCap = bangCap;
    }

    public Integer getKinhNghiem() {
        return kinhNghiem;
    }

    public void setKinhNghiem(Integer kinhNghiem) {
        this.kinhNghiem = kinhNghiem;
    }

    //public String getPhong() {
    //    return phong;
    //}

    //public void setPhong(String phong) {
    //    this.phong = phong;
    //}

    //public Integer getSoBenhNhanNgay() {
    //    return soBenhNhanNgay;
    //}

    //public void setSoBenhNhanNgay(Integer soBenhNhanNgay) {
    //    this.soBenhNhanNgay = soBenhNhanNgay;
    //}

    public Khoa getKhoa() {
        return khoa;
    }

    public void setKhoa(Khoa khoa) {
        this.khoa = khoa;
    }
}
