package app.business.giaodich;

import app.business.nguoidung.BacSi;
import app.business.nguoidung.BenhNhan;
import app.business.vatchat.CaKham;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import javax.persistence.*;
import java.sql.Time;

@Entity
@Table(name = "LichHen")
public class LichHen implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "lichHenId")
    private int lichHenId;
    @ManyToOne
    @JoinColumn(name = "idBenhNhan")
    private BenhNhan benhNhan;
    @Column(name = "idPhong")
    private int idPhong;
    @ManyToOne
    @JoinColumn(name = "idBacSi")
    private BacSi bacSi;

    @Temporal(TemporalType.DATE)
    @Column(name = "NgayHen", nullable = false)
    private Date ngayHen;
    @Column(name = "ngay") 
    private Date ngay;

    private String lyDoKham;

    private BigDecimal chiPhi;

    private String trangThai;
    @Column(name = "timeStart", nullable = false)
    private Time gioBatDau;
    @Column(name = "timeEnd", nullable = false)
    private Time gioKetThuc;

    @ManyToOne
    @JoinColumn(name = "idCa") // FK tới bảng CaKham
    private CaKham caKham;
    
    
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

    
    // Getters and Setters
    public int getLichHenId() {
        return lichHenId;
    }

    public void setLichHenId(int lichHenId) {
        this.lichHenId = lichHenId;
    }

    public BenhNhan getBenhNhan() {
        return benhNhan;
    }

    public void setBenhNhan(BenhNhan benhNhan) {
        this.benhNhan = benhNhan;
    }

    public BacSi getBacSi() {
        return bacSi;
    }

    public void setBacSi(BacSi bacSi) {
        this.bacSi = bacSi;
    }

    public Date getNgayHen() {
        return ngayHen;
    }

    public void setNgayHen(Date ngayHen) {
        this.ngayHen = ngayHen;
    }

    public String getLyDoKham() {
        return lyDoKham;
    }

    public void setLyDoKham(String lyDoKham) {
        this.lyDoKham = lyDoKham;
    }

    public BigDecimal getChiPhi() {
        return chiPhi;
    }

    public void setChiPhi(BigDecimal chiPhi) {
        this.chiPhi = chiPhi;
    }

    public String getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }
    
    public CaKham getCaKham() {
        return caKham;
    }

        public void setCaKham(CaKham caKham) {
            this.caKham = caKham;
            if (caKham != null) {
                this.ngay = caKham.getNgay();
                this.gioBatDau = caKham.getGioBatDau();
                this.gioKetThuc = caKham.getGioKetThuc();
            }
        }

    public int getIdPhong() { return idPhong; }
    public void setIdPhong(int idPhong) { this.idPhong = idPhong; }
    public String toString() {
        return "LichHen{" +
                "id=" + lichHenId +
                ", lyDoKham='" + lyDoKham + '\'' +
                ", chiPhi=" + chiPhi +
                ", trangThai='" + trangThai + '\'' +
                ", ngayHen=" + ngayHen +
                ", ngay=" + ngay +
                ", caKham=" + (caKham != null ? caKham.getCaId() : "null") +
                '}';
    }
}


