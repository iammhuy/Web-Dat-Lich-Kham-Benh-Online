package app.business.hosokham;

import javax.persistence.*;

@Entity
@Table(name = "ChiTietDonThuoc")
public class ChiTietDonThuoc {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer chiTietDonThuocId;

    @Column(nullable = false)
    private Integer donThuocId;

    @Column(nullable = false)
    private Integer thuocId;

    private Integer soLuong;
    private String cachDung;

    public ChiTietDonThuoc() {}

    public Integer getChiTietDonThuocId() { return chiTietDonThuocId; }
    public void setChiTietDonThuocId(Integer id) { this.chiTietDonThuocId = id; }
    public Integer getDonThuocId() { return donThuocId; }
    public void setDonThuocId(Integer donThuocId) { this.donThuocId = donThuocId; }
    public Integer getThuocId() { return thuocId; }
    public void setThuocId(Integer thuocId) { this.thuocId = thuocId; }
    public Integer getSoLuong() { return soLuong; }
    public void setSoLuong(Integer soLuong) { this.soLuong = soLuong; }
    public String getCachDung() { return cachDung; }
    public void setCachDung(String cachDung) { this.cachDung = cachDung; }
}
