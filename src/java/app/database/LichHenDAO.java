package app.database;

import app.business.giaodich.LichHen;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import java.util.List;

public class LichHenDAO {

    // Thêm lịch hẹn mới vào CSDL
    public static LichHen insert(LichHen lichHen) {
    EntityManager em = DBUtil.getEmFactory().createEntityManager();
    EntityTransaction trans = em.getTransaction();
    try {
        trans.begin();
        em.persist(lichHen);
        trans.commit();
        return lichHen;
    } catch (Exception e) {
        System.out.println("Lỗi insert lịch hẹn: " + e.getMessage());
        if (trans.isActive()) { // ⚠️ kiểm tra trước khi rollback
            trans.rollback();
        }
        e.printStackTrace();
    } finally {
        em.close();
    }
    return null;
}


    // Lấy lịch hẹn theo ID
    public static LichHen getById(int lichHenId) {
        EntityManager em = DBUtil.getEmFactory().createEntityManager();
        try {
            return em.find(LichHen.class, lichHenId);
        } finally {
            em.close();
        }
    }

    // Lấy danh sách lịch hẹn theo bệnh nhân và trạng thái
   // Lấy danh sách lịch hẹn theo bệnh nhân và trạng thái
// Lấy danh sách lịch hẹn theo bệnh nhân và trạng thái
public static List<LichHen> findByBenhNhanAndTrangThai(Long benhNhanId, String trangThai) {
    EntityManager em = DBUtil.getEmFactory().createEntityManager();
    try {
        return em.createQuery(
                "SELECT l FROM LichHen l WHERE l.benhNhan.userId = :id AND l.trangThai = :tt ORDER BY l.ngayHen DESC",
                LichHen.class)
                .setParameter("id", benhNhanId)
                .setParameter("tt", trangThai)
                .getResultList();
    } finally {
        em.close();
    }
}

// Lấy toàn bộ lịch hẹn của bệnh nhân (bất kể trạng thái)
public static List<LichHen> findAllByBenhNhan(Long benhNhanId) {
    EntityManager em = DBUtil.getEmFactory().createEntityManager();
    try {
        return em.createQuery(
                "SELECT l FROM LichHen l WHERE l.benhNhan.userId = :id ORDER BY l.ngayHen DESC",
                LichHen.class)
                .setParameter("id", benhNhanId)
                .getResultList();
    } finally {
        em.close();
    }
}



    // Cập nhật trạng thái lịch hẹn (ví dụ khi thanh toán VNPAY thành công)
    public static void updateTrangThai(int lichHenId, String trangThai) {
        EntityManager em = DBUtil.getEmFactory().createEntityManager();
        EntityTransaction trans = em.getTransaction();
        trans.begin();
        try {
            LichHen lichHen = em.find(LichHen.class, lichHenId);
            if (lichHen != null) {
                lichHen.setTrangThai(trangThai);
                em.merge(lichHen);
            }
            trans.commit();
        } catch (Exception e) {
            System.out.println("Lỗi cập nhật trạng thái: " + e.getMessage());
            trans.rollback();
        } finally {
            em.close();
        }
    }
}
