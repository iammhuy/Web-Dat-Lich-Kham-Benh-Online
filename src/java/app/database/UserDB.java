/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package app.database;

/**
 *
 * @author Nhat Huy
 */
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import java.util.List;
import app.business.nguoidung.User;
public class UserDB {

    public static void insert(User user) {
        EntityManager em = DBUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(user);
            tx.commit();
        } catch (Exception ex) {
            if (tx.isActive()) tx.rollback();
            throw new RuntimeException(ex);
        } finally {
            em.close();
        }
    }

    public static void update(User user) {
        EntityManager em = DBUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.merge(user);
            tx.commit();
        } catch (Exception ex) {
            if (tx.isActive()) tx.rollback();
            throw new RuntimeException(ex);
        } finally {
            em.close();
        }
    }

    public static void delete(Long userId) {
        EntityManager em = DBUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            User u = em.find(User.class, userId);
            if (u != null) {
                em.remove(u);
            }
            tx.commit();
        } catch (Exception ex) {
            if (tx.isActive()) tx.rollback();
            throw new RuntimeException(ex);
        } finally {
            em.close();
        }
    }

    public static List<User> selectUsers() {
        EntityManager em = DBUtil.getEntityManager();
        try {
            return em.createQuery("SELECT u FROM User u ORDER BY u.userId", User.class)
                     .getResultList();
        } finally {
            em.close();
        }
    }

    public static User selectUserById(Long id) {
        EntityManager em = DBUtil.getEntityManager();
        try {
            return em.find(User.class, id);
        } finally {
            em.close();
        }
    }

    public static User selectUserByEmail(String email) {
        EntityManager em = DBUtil.getEntityManager();
        try {
            List<User> list = em.createQuery("SELECT u FROM User u WHERE u.email = :email", User.class)
                                .setParameter("email", email)
                                .getResultList();
            return list.isEmpty()? null : list.get(0);
        } finally {
            em.close();
        }
    }
}