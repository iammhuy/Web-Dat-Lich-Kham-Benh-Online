package app.business.vatchat;

import java.io.Serializable;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "Khoa") // Đảm bảo tên bảng khớp với CSDL
public class Khoa implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID") // Đảm bảo tên cột ID khớp
    private int idKhoa;

    @Column(name = "TENKHOA") // Đảm bảo tên cột khớp
    private String tenKhoa;
    
    // =============================================================
    // THÊM THUỘC TÍNH MỚI
    // =============================================================
    @Column(name = "MO_TA") // Ánh xạ tới cột MO_TA trong CSDL
    private String moTa;
    // =============================================================

    // Constructors
    public Khoa() {
    }

    // Getters and Setters
    public int getIdKhoa() {
        return idKhoa;
    }

    public void setIdKhoa(int idKhoa) {
        this.idKhoa = idKhoa;
    }

    public String getTenKhoa() {
        return tenKhoa;
    }

    public void setTenKhoa(String tenKhoa) {
        this.tenKhoa = tenKhoa;
    }

    // =============================================================
    // THÊM GETTER VÀ SETTER MỚI
    // =============================================================
    public String getMoTa() {
        return moTa;
    }

    public void setMoTa(String moTa) {
        this.moTa = moTa;
    }
    // =============================================================
}
