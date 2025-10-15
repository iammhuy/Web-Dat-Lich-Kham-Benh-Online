package app.database;

import app.business.vatchat.CaKham;
import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;
import java.sql.Date;
import java.util.List;

public class CaKhamDAO {

    private final EntityManager em = DBUtil.getEmFactory().createEntityManager();

    // Lấy toàn bộ ca khám
    public List<CaKham> getAllCaKham() {
        String jpql = "SELECT c FROM CaKham c ORDER BY c.ngay, c.gioBatDau";
        TypedQuery<CaKham> query = em.createQuery(jpql, CaKham.class);
        return query.getResultList();
    }

    // Lấy danh sách ca khám theo ngày
    public List<CaKham> getCaKhamByNgay(Date ngay) {
        String jpql = "SELECT c FROM CaKham c WHERE c.ngay = :ngay ORDER BY c.gioBatDau";
        TypedQuery<CaKham> query = em.createQuery(jpql, CaKham.class);
        query.setParameter("ngay", ngay);
        return query.getResultList();
    }

    // Lấy chi tiết 1 ca theo ID
    public CaKham getCaKhamById(int caId) {
        return em.find(CaKham.class, caId);
    }
    
}
