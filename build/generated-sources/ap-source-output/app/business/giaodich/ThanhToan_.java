package app.business.giaodich;

import app.business.giaodich.PhuongThuc;
import app.business.giaodich.TrangThai;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import javax.annotation.processing.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-10-13T19:57:28", comments="EclipseLink-2.7.12.v20230209-rNA")
@StaticMetamodel(ThanhToan.class)
public class ThanhToan_ { 

    public static volatile SingularAttribute<ThanhToan, String> maGiaoDichVnpay;
    public static volatile SingularAttribute<ThanhToan, Integer> thanhToanId;
    public static volatile SingularAttribute<ThanhToan, TrangThai> trangThai;
    public static volatile SingularAttribute<ThanhToan, LocalDateTime> ngayThanhToan;
    public static volatile SingularAttribute<ThanhToan, PhuongThuc> phuongThuc;
    public static volatile SingularAttribute<ThanhToan, Integer> lichHenId;
    public static volatile SingularAttribute<ThanhToan, BigDecimal> soTien;

}