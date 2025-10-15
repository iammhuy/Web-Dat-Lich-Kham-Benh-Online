package app.database;

import app.business.nguoidung.BacSi;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import javax.persistence.NoResultException;
import javax.persistence.TypedQuery;

public class BacSiDAO {
    
    // Phương thức để THÊM mới một bác sĩ
    public static void insert(BacSi bacSi) {
        EntityManager em = DBUtil.getEmFactory().createEntityManager();
        EntityTransaction trans = em.getTransaction();
        trans.begin();
        try {
            em.persist(bacSi);
            trans.commit();
        } catch (Exception e) {
            System.out.println(e);
            trans.rollback();
        } finally {
            em.close();
        }
    }

    // Phương thức để CẬP NHẬT thông tin một bác sĩ
    public static void update(BacSi bacSi) {
        EntityManager em = DBUtil.getEmFactory().createEntityManager();
        EntityTransaction trans = em.getTransaction();
        trans.begin();
        try {
            em.merge(bacSi);
            trans.commit();
        } catch (Exception e) {
            System.out.println(e);
            trans.rollback();
        } finally {
            em.close();
        }
    }

    // Phương thức để XÓA một bác sĩ
    public static void delete(BacSi bacSi) {
        EntityManager em = DBUtil.getEmFactory().createEntityManager();
        EntityTransaction trans = em.getTransaction();
        trans.begin();
        try {
            // Cần merge trước khi remove để entity được quản lý bởi EntityManager
            em.remove(em.merge(bacSi));
            trans.commit();
        } catch (Exception e) {
            System.out.println(e);
            trans.rollback();
        } finally {
            em.close();
        }
    }

    // Phương thức để TÌM bác sĩ theo ID (kiểu int)
    public static BacSi findById(long idBacSi) {
        EntityManager em = DBUtil.getEmFactory().createEntityManager();
        try {
            return em.find(BacSi.class, idBacSi);
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }
    
    // Phương thức để TÌM bác sĩ theo Khoa (kiểu int)
    public static List<BacSi> findByKhoa(int idKhoa) {
        EntityManager em = DBUtil.getEmFactory().createEntityManager();
        String qString = "SELECT b FROM BacSi b WHERE b.khoa.idKhoa = :idKhoa ORDER BY b.lastName, b.firstName";
        TypedQuery<BacSi> q = em.createQuery(qString, BacSi.class);
        q.setParameter("idKhoa", idKhoa);
        
        List<BacSi> bacSiList = null;
        try {
            bacSiList = q.getResultList();
        } finally {
            em.close();
        }
        return bacSiList;
    }

    // Phương thức để LẤY TẤT CẢ bác sĩ
    public static List<BacSi> findAll() {
        EntityManager em = DBUtil.getEmFactory().createEntityManager();
        String qString = "SELECT b FROM BacSi b ORDER BY b.lastName, b.firstName";
        TypedQuery<BacSi> q = em.createQuery(qString, BacSi.class);
        
        List<BacSi> bacSiList = null;
        try {
            bacSiList = q.getResultList();
        } finally {
            em.close();
        }
        return bacSiList;
    }
}