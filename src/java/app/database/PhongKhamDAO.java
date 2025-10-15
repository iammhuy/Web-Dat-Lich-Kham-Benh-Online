package app.database;

import app.business.vatchat.PhongKham;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;
import java.util.Collections;
import java.util.Date;

public class PhongKhamDAO {
    
    public static String getTenPhongById(int idPhong) {
        EntityManager em = DBUtil.getEmFactory().createEntityManager();
        try {
            Object ten = em.createQuery("SELECT p.tenPhong FROM PhongKham p WHERE p.phongId = :id")
                .setParameter("id", idPhong)
                .getSingleResult();
            return ten != null ? ten.toString() : "Không xác định";
        } catch (Exception e) {
            return "Không xác định";
        } finally {
            em.close();
        }
    }

    /**
     * Tìm 1 phòng trong khoa (khoaId) chưa bị đặt cho ngày 'ngay' và ca 'caId'.
     * Tránh các lịch đã có trạng thái "Đã xác nhận" hoặc "Đã duyệt" (có thể mở rộng).
     */
    public static PhongKham findAvailablePhongFor(int khoaId, java.util.Date ngay, int caId) {
        EntityManager em = DBUtil.getEmFactory().createEntityManager();
        try {
            // 1) Lấy danh sách phòng thuộc khoa
            TypedQuery<PhongKham> q = em.createQuery(
                "SELECT p FROM PhongKham p WHERE p.khoa.idKhoa = :khoaId", PhongKham.class);
            q.setParameter("khoaId", khoaId);
            List<PhongKham> dsPhong = q.getResultList();
            if (dsPhong == null || dsPhong.isEmpty()) return null;

            // 2) Lấy danh sách id phòng đã bị chặn cho ngày+ca
            TypedQuery<Integer> q2 = em.createQuery(
                "SELECT l.idPhong FROM LichHen l " +
                "WHERE l.ngay = :ngay AND l.caKham.caId = :caId AND l.trangThai IN ('Đã xác nhận','Đã duyệt')",
                Integer.class);
            q2.setParameter("ngay", ngay);
            q2.setParameter("caId", caId);
            List<Integer> occupied = q2.getResultList();
            if (occupied == null) occupied = Collections.emptyList();

            // 3) Trả phòng đầu tiên không trong occupied
            for (PhongKham p : dsPhong) {
                if (p.getPhongId() == null) continue;
                if (!occupied.contains(p.getPhongId())) return p;
            }
            return null;
        } finally {
            em.close();
        }
    }

    
}
