package app.business.hosokham;

import javax.persistence.*;

@Entity
@Table(name = "Thuoc")
public class Thuoc {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer thuocId;

    private String tenThuoc;
    private String congDung;

    public Thuoc() {}

    public Integer getThuocId() { return thuocId; }
    public void setThuocId(Integer thuocId) { this.thuocId = thuocId; }
    public String getTenThuoc() { return tenThuoc; }
    public void setTenThuoc(String tenThuoc) { this.tenThuoc = tenThuoc; }
    public String getCongDung() { return congDung; }
    public void setCongDung(String congDung) { this.congDung = congDung; }
}
