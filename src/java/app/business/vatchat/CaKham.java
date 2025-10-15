package app.business.vatchat;

import javax.persistence.*;
import java.sql.Date;
import java.sql.Time;

@Entity
@Table(name = "CaKham")
public class CaKham {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "caId")
    private int caId;

    @Column(name = "ten_ca")
    private String tenCa;

    @Column(name = "gioBatDau")
    private Time gioBatDau;

    @Column(name = "gioKetThuc")
    private Time gioKetThuc;

    @Column(name = "ngay")
    private Date ngay;

    public CaKham() {}

    public CaKham(int caId, String tenCa, Time gioBatDau, Time gioKetThuc, Date ngay) {
        this.caId = caId;
        this.tenCa = tenCa;
        this.gioBatDau = gioBatDau;
        this.gioKetThuc = gioKetThuc;
        this.ngay = ngay;
    }

    public int getCaId() {
        return caId;
    }

    public void setCaId(int caId) {
        this.caId = caId;
    }

    public String getTenCa() {
        return tenCa;
    }

    public void setTenCa(String tenCa) {
        this.tenCa = tenCa;
    }

    public Time getGioBatDau() {
        return gioBatDau;
    }

    public void setGioBatDau(Time gioBatDau) {
        this.gioBatDau = gioBatDau;
    }

    public Time getGioKetThuc() {
        return gioKetThuc;
    }

    public void setGioKetThuc(Time gioKetThuc) {
        this.gioKetThuc = gioKetThuc;
    }
    
    public Date getNgay() {
        return ngay;
    }

    public void setNgay(Date ngay) {
        this.ngay = ngay;
    }

    @Override
    public String toString() {
        return "CaKham{" +
                "caId=" + caId +
                ", tenCa='" + tenCa + '\'' +
                ", gioBatDau=" + gioBatDau +
                ", gioKetThuc=" + gioKetThuc +
                ", ngay=" + ngay +
                '}';
    }
}
