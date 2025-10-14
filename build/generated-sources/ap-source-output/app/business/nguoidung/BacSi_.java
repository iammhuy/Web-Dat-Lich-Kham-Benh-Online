package app.business.nguoidung;

import app.business.vatchat.Khoa;
import javax.annotation.processing.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-10-14T20:30:19", comments="EclipseLink-2.7.12.v20230209-rNA")
@StaticMetamodel(BacSi.class)
public class BacSi_ extends User_ {

    public static volatile SingularAttribute<BacSi, String> chuyenNganh;
    public static volatile SingularAttribute<BacSi, Double> chiPhiKham;
    public static volatile SingularAttribute<BacSi, Integer> kinhNghiem;
    public static volatile SingularAttribute<BacSi, String> bangCap;
    public static volatile SingularAttribute<BacSi, Khoa> khoa;

}