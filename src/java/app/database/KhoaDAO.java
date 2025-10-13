package app.database;

import app.business.vatchat.Khoa;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.TypedQuery;

public class KhoaDAO {

    /**
     * Lấy tất cả các khoa từ cơ sở dữ liệu.
     * @return Danh sách các khoa.
     */
    public static List<Khoa> findAll() {
        EntityManager em = DBUtil.getEmFactory().createEntityManager();
        String qString = "SELECT k FROM Khoa k ORDER BY k.tenKhoa";
        TypedQuery<Khoa> q = em.createQuery(qString, Khoa.class);
        
        List<Khoa> khoaList;
        try {
            khoaList = q.getResultList();
            if (khoaList == null || khoaList.isEmpty()) {
                khoaList = null;
            }
        } finally {
            em.close();
        }
        return khoaList;
    }
    
    /**
     * Tìm một khoa dựa trên ID.
     * @param idKhoa ID của khoa cần tìm.
     * @return Đối tượng Khoa hoặc null nếu không tìm thấy.
     */
    public static Khoa findById(int idKhoa) {
        EntityManager em = DBUtil.getEmFactory().createEntityManager();
        try {
            return em.find(Khoa.class, idKhoa);
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }
}
