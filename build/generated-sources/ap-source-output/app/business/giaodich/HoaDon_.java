package app.business.giaodich;

import app.business.giaodich.ThanhToan;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import javax.annotation.processing.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-10-14T14:31:41", comments="EclipseLink-2.7.12.v20230209-rNA")
@StaticMetamodel(HoaDon.class)
public class HoaDon_ { 

    public static volatile SingularAttribute<HoaDon, ThanhToan> thanhToan;
    public static volatile SingularAttribute<HoaDon, Integer> hoaDonId;
    public static volatile SingularAttribute<HoaDon, BigDecimal> soTien;
    public static volatile SingularAttribute<HoaDon, String> noiDung;
    public static volatile SingularAttribute<HoaDon, LocalDateTime> ngayXuat;

}