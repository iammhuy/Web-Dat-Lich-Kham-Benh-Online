package app.business.giaodich;

import app.business.nguoidung.BacSi;
import app.business.nguoidung.BenhNhan;
import app.business.vatchat.CaKham;
import java.math.BigDecimal;
import java.sql.Time;
import java.util.Date;
import javax.annotation.processing.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-10-15T07:20:09", comments="EclipseLink-2.7.12.v20230209-rNA")
@StaticMetamodel(LichHen.class)
public class LichHen_ { 

    public static volatile SingularAttribute<LichHen, Date> ngay;
    public static volatile SingularAttribute<LichHen, Time> gioBatDau;
    public static volatile SingularAttribute<LichHen, String> trangThai;
    public static volatile SingularAttribute<LichHen, BigDecimal> chiPhi;
    public static volatile SingularAttribute<LichHen, BenhNhan> benhNhan;
    public static volatile SingularAttribute<LichHen, BacSi> bacSi;
    public static volatile SingularAttribute<LichHen, Time> gioKetThuc;
    public static volatile SingularAttribute<LichHen, Integer> lichHenId;
    public static volatile SingularAttribute<LichHen, String> lyDoKham;
    public static volatile SingularAttribute<LichHen, CaKham> caKham;
    public static volatile SingularAttribute<LichHen, Integer> idPhong;
    public static volatile SingularAttribute<LichHen, Date> ngayHen;

}