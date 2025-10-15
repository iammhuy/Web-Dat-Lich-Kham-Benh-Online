package app.business.hosokham;

import javax.persistence.*;

@Entity
@Table(name = "HoSoKham")
public class HoSoKham {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer hoSoId;

    @Column(nullable = false)
    private Integer lichHenId;

    @Lob
    private String ketQua;

    public HoSoKham() {}

    public Integer getHoSoId() { return hoSoId; }
    public void setHoSoId(Integer hoSoId) { this.hoSoId = hoSoId; }

    public Integer getLichHenId() { return lichHenId; }
    public void setLichHenId(Integer lichHenId) { this.lichHenId = lichHenId; }

    public String getKetQua() { return ketQua; }
    public void setKetQua(String ketQua) { this.ketQua = ketQua; }
}
