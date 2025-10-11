package app.database;

import app.business.nguoidung.BacSi;
import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;
import java.util.List;

public class BacSiDB {

    public static List<BacSi> getAll() {
        EntityManager em = DBUtil.getEntityManager();
        try {
            TypedQuery<BacSi> query = em.createQuery("SELECT b FROM BacSi b", BacSi.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public static BacSi findById(Long id) {
        EntityManager em = DBUtil.getEntityManager();
        try {
            return em.find(BacSi.class, id);
        } finally {
            em.close();
        }
    }

    public static void insert(BacSi bacSi) {
        EntityManager em = DBUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(bacSi);
            em.getTransaction().commit();
        } finally {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            em.close();
        }
    }

    public static void update(BacSi bacSi) {
        EntityManager em = DBUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(bacSi);
            em.getTransaction().commit();
        } finally {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            em.close();
        }
    }

    public static void delete(Long id) {
        EntityManager em = DBUtil.getEntityManager();
        try {
            BacSi bacSi = em.find(BacSi.class, id);
            if (bacSi != null) {
                em.getTransaction().begin();
                em.remove(bacSi);
                em.getTransaction().commit();
            }
        } finally {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            em.close();
        }
    }
}
