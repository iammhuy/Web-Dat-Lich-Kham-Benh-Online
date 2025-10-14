//package app.business.nguoidung;
//
//import app.business.nguoidung.QuanTriVien;
//import app.database.DBUtil;
//import app.database.DBUtil;
//import org.mindrot.jbcrypt.BCrypt;
//
//import javax.persistence.EntityManager;
//import javax.persistence.EntityTransaction;
//
//public class test {
//    public static void main(String[] args) {
//        EntityManager em = DBUtil.getEmFactory().createEntityManager();
//        EntityTransaction trans = em.getTransaction();
//        try {
//            trans.begin();
//
//            QuanTriVien admin = new QuanTriVien();
//            admin.setEmail("admin@hospital.com");
//            admin.setFirstName("Quản trị");
//            admin.setLastName("Viên");
//            admin.setPasswordHash(BCrypt.hashpw("admin123", BCrypt.gensalt(12)));
//            admin.setGender("Nam");
//            admin.setPhoneNumber("0123456789");
//            admin.setAddress("HCM");
//
//            em.persist(admin); // JPA tự insert vào cả User + QuanTriVien
//
//            trans.commit();
//            System.out.println("✅ Tạo admin thành công!");
//        } catch (Exception e) {
//            e.printStackTrace();
//            trans.rollback();
//        } finally {
//            em.close();
//        }
//    }
//}
