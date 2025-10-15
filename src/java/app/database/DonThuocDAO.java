package app.database;

import app.business.hosokham.DonThuoc;
import javax.persistence.*;

public class DonThuocDAO {
    public DonThuoc create(DonThuoc d) {
        EntityManager em = DBUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(d);
            em.getTransaction().commit();
            return d;
        } catch(Exception ex) {
            if(em.getTransaction().isActive()) em.getTransaction().rollback();
            throw ex;
        } finally {
            em.close();
        }
    }

    public DonThuoc findById(int id) {
        EntityManager em = DBUtil.getEntityManager();
        try {
            return em.find(DonThuoc.class, id);
        } finally {
            em.close();
        }
    }
}
