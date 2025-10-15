package app.business.hosokham;

import javax.persistence.*;
import java.util.List;

@Entity
@Table(name = "DonThuoc")
public class DonThuoc {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer donThuocId;

    @Column(nullable = false)
    private Integer hoSoId;

    @Lob
    private String huongDan;

    public DonThuoc() {}

    public Integer getDonThuocId() { return donThuocId; }
    public void setDonThuocId(Integer donThuocId) { this.donThuocId = donThuocId; }
    public Integer getHoSoId() { return hoSoId; }
    public void setHoSoId(Integer hoSoId) { this.hoSoId = hoSoId; }
    public String getHuongDan() { return huongDan; }
    public void setHuongDan(String huongDan) { this.huongDan = huongDan; }
}
