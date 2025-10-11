package app.business.vatchat;

import app.database.DBUtil;
import javax.persistence.EntityManager;
import java.util.List;

public class KhoaDAO {

    public List<Khoa> findAll() {
        EntityManager em = DBUtil.getEntityManager();
        try {
            return em.createQuery("SELECT k FROM Khoa k", Khoa.class)
                     .getResultList();
        } finally {
            em.close();
        }
    }

    public Khoa findById(Long id) {
        EntityManager em = DBUtil.getEntityManager();
        try {
            return em.find(Khoa.class, id);
        } finally {
            em.close();
        }
    }
}
