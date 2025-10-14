package app.database;

import app.business.nguoidung.User;
import javax.persistence.*;
import java.util.List;
import org.mindrot.jbcrypt.BCrypt;

public class UserDB {

    public static void insert(User user) {
        EntityManager em = DBUtil.getEmFactory().createEntityManager();
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
        EntityManager em = DBUtil.getEmFactory().createEntityManager();
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

    public static User selectUserByEmail(String email) {
        EntityManager em = DBUtil.getEmFactory().createEntityManager();
        try {
            List<User> list = em.createQuery("SELECT u FROM User u WHERE u.email = :email", User.class)
                                .setParameter("email", email)
                                .getResultList();
            return list.isEmpty() ? null : list.get(0);
        } finally {
            em.close();
        }
    }

    public static User authenticate(String email, String plainPassword) {
        User u = selectUserByEmail(email);
        if (u == null) return null;
        String hash = u.getPasswordHash();
        if (hash == null) return null;
        return BCrypt.checkpw(plainPassword, hash) ? u : null;
    }
}
