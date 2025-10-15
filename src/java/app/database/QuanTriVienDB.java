package app.database;

import app.business.nguoidung.BacSi;
import app.business.vatchat.Khoa;
import app.business.vatchat.PhongKham;

import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import javax.persistence.TypedQuery;


public class QuanTriVienDB {

    // ---------------------- Bác sĩ ----------------------
    public static void insertBacSi(BacSi b) {
        EntityManager em = DBUtil.getEmFactory().createEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(b);
            tx.commit();
        } catch (Exception ex) {
            if (tx.isActive()) tx.rollback();
            throw new RuntimeException(ex);
        } finally {
            em.close();
        }
    }

    public static void updateBacSi(BacSi b) {
        EntityManager em = DBUtil.getEmFactory().createEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.merge(b);
            tx.commit();
        } catch (Exception ex) {
            if (tx.isActive()) tx.rollback();
            throw new RuntimeException(ex);
        } finally {
            em.close();
        }
    }

    public static void deleteBacSi(BacSi b) {
        EntityManager em = DBUtil.getEmFactory().createEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.remove(em.merge(b));
            tx.commit();
        } catch (Exception ex) {
            if (tx.isActive()) tx.rollback();
            throw new RuntimeException(ex);
        } finally {
            em.close();
        }
    }

    public static BacSi findBacSiById(Long id) {
        EntityManager em = DBUtil.getEmFactory().createEntityManager();
        try {
            return em.find(BacSi.class, id);
        } finally {
            em.close();
        }
    }

    public static List<BacSi> listBacSi() {
        EntityManager em = DBUtil.getEmFactory().createEntityManager();
        try {
            TypedQuery<BacSi> q = em.createQuery("SELECT b FROM BacSi b ORDER BY b.lastName, b.firstName", BacSi.class);
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    // ---------------------- Khoa ----------------------
    public static void insertKhoa(Khoa k) {
        EntityManager em = DBUtil.getEmFactory().createEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(k);
            tx.commit();
        } catch (Exception ex) {
            if (tx.isActive()) tx.rollback();
            throw new RuntimeException(ex);
        } finally {
            em.close();
        }
    }

    public static void updateKhoa(Khoa k) {
        EntityManager em = DBUtil.getEmFactory().createEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.merge(k);
            tx.commit();
        } catch (Exception ex) {
            if (tx.isActive()) tx.rollback();
            throw new RuntimeException(ex);
        } finally {
            em.close();
        }
    }

    public static void deleteKhoa(Khoa k) {
        EntityManager em = DBUtil.getEmFactory().createEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.remove(em.merge(k));
            tx.commit();
        } catch (Exception ex) {
            if (tx.isActive()) tx.rollback();
            throw new RuntimeException(ex);
        } finally {
            em.close();
        }
    }

    public static Khoa findKhoaById(int id) {
        EntityManager em = DBUtil.getEmFactory().createEntityManager();
        try {
            return em.find(Khoa.class, id);
        } finally {
            em.close();
        }
    }

    public static List<Khoa> listKhoa() {
        EntityManager em = DBUtil.getEmFactory().createEntityManager();
        try {
            TypedQuery<Khoa> q = em.createQuery("SELECT k FROM Khoa k ORDER BY k.tenKhoa", Khoa.class);
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    // ---------------------- Phòng khám ----------------------
    public static void insertPhong(PhongKham p) {
        EntityManager em = DBUtil.getEmFactory().createEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(p);
            tx.commit();
        } catch (Exception ex) {
            if (tx.isActive()) tx.rollback();
            throw new RuntimeException(ex);
        } finally {
            em.close();
        }
    }

    public static void updatePhong(PhongKham p) {
        EntityManager em = DBUtil.getEmFactory().createEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.merge(p);
            tx.commit();
        } catch (Exception ex) {
            if (tx.isActive()) tx.rollback();
            throw new RuntimeException(ex);
        } finally {
            em.close();
        }
    }

    public static void deletePhong(PhongKham p) {
        EntityManager em = DBUtil.getEmFactory().createEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.remove(em.merge(p));
            tx.commit();
        } catch (Exception ex) {
            if (tx.isActive()) tx.rollback();
            throw new RuntimeException(ex);
        } finally {
            em.close();
        }
    }

    public static PhongKham findPhongById(int id) {
        EntityManager em = DBUtil.getEmFactory().createEntityManager();
        try {
            return em.find(PhongKham.class, id);
        } finally {
            em.close();
        }
    }

    public static List<PhongKham> listPhong() {
        EntityManager em = DBUtil.getEmFactory().createEntityManager();
        try {
            TypedQuery<PhongKham> q = em.createQuery("SELECT p FROM PhongKham p ORDER BY p.tenPhong", PhongKham.class);
            return q.getResultList();
        } finally {
            em.close();
        }
    }
}
