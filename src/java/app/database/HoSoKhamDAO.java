package app.database;

import app.business.hosokham.HoSoKham;
import javax.persistence.*;
import java.util.List;

public class HoSoKhamDAO {

    public HoSoKham create(HoSoKham hs) {
        EntityManager em = DBUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(hs);
            em.flush();      // đảm bảo ID được tạo
            em.refresh(hs);  // cập nhật lại đối tượng có ID
            em.getTransaction().commit();
            return hs;
        } catch (Exception ex) {

            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            ex.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public HoSoKham findById(int id) {
        EntityManager em = DBUtil.getEntityManager();
        try {
            return em.find(HoSoKham.class, id);
        } finally {
            em.close();
        }
    }

    public List<HoSoKham> findByBenhNhanId(long idBenhNhan) {
        EntityManager em = DBUtil.getEntityManager();
        try {
            String sql = "SELECT h.* FROM HoSoKham h JOIN LichHen l ON h.lichHenId = l.lichHenId WHERE l.idBenhNhan = :uid";
            Query q = em.createNativeQuery(sql, HoSoKham.class);
            q.setParameter("uid", idBenhNhan);
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    public HoSoKham update(HoSoKham hs) {
        EntityManager em = DBUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            HoSoKham merged = em.merge(hs);
            em.getTransaction().commit();
            return merged;
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            ex.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }
}
