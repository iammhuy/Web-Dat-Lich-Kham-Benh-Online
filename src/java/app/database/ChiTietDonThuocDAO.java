package app.database;

import app.business.hosokham.ChiTietDonThuoc;
import javax.persistence.*;
import java.util.List;

public class ChiTietDonThuocDAO {
    public ChiTietDonThuoc create(ChiTietDonThuoc ct) {
        EntityManager em = DBUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(ct);
            em.getTransaction().commit();
            return ct;
        } catch(Exception ex) {
            if(em.getTransaction().isActive()) em.getTransaction().rollback();
            throw ex;
        } finally {
            em.close();
        }
    }

    public List<ChiTietDonThuoc> findByDonThuocId(int donThuocId) {
        EntityManager em = DBUtil.getEntityManager();
        try {
            TypedQuery<ChiTietDonThuoc> q = em.createQuery(
                "SELECT c FROM ChiTietDonThuoc c WHERE c.donThuocId = :dtid", ChiTietDonThuoc.class);
            q.setParameter("dtid", donThuocId);
            return q.getResultList();
        } finally {
            em.close();
        }
    }
}
