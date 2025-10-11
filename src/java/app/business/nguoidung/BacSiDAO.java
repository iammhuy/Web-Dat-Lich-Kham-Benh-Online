package app.business.nguoidung;

import app.database.DBUtil;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import java.util.List;
import javax.persistence.NoResultException;
        
public class BacSiDAO {

    public BacSi findById(Long id) {
        EntityManager em = DBUtil.getEntityManager();
        try {
            return em.find(BacSi.class, id);
        } finally {
            em.close();
        }
    }

    public List<BacSi> findAll() {
        EntityManager em = DBUtil.getEntityManager();
        try {
            return em.createQuery("SELECT b FROM BacSi b", BacSi.class).getResultList();
        } finally {
            em.close();
        }
    }

    public void saveOrUpdate(BacSi bacSi) {
        EntityManager em = DBUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            if (bacSi.getId() == null) {
                em.persist(bacSi);
            } else {
                em.merge(bacSi);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public void delete(Long id) {
        EntityManager em = DBUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            BacSi bacSi = em.find(BacSi.class, id);
            if (bacSi != null) {
                em.remove(bacSi);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } finally {
            em.close();
        }
    }
    public BacSi findByEmail(String email) {
        EntityManager em = DBUtil.getEntityManager();
        try {
            return em.createQuery("SELECT b FROM BacSi b WHERE b.email = :email", BacSi.class)
                     .setParameter("email", email)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }
}
