package app.controller;

import app.business.giaodich.LichHen;
import app.business.nguoidung.BacSi;
import app.business.nguoidung.BenhNhan;
import app.business.vatchat.Khoa;
import app.business.vatchat.CaKham;

import app.database.BacSiDAO;
import app.database.KhoaDAO;
import app.database.PhongKhamDAO;
import app.database.LichHenDAO;
import app.database.CaKhamDAO;
    
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LichHenController")
public class LichHenController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        
        
        // ========Nhất Huy thêm==========================================================
        
            if ("assignRoom".equals(action)) {
            assignRoomAndRedirect(req, res);
            return;
            }
        //==============================================================================
        if (action == null || "prepareAdd".equals(action) || "form".equals(action)) {
            prepareAdd(req, res);
        } else if ("list".equals(action)) {
            hienThiDanhSach(req, res);
        } else {
            res.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if ("add".equals(action)) {
            themLich(req, res);
        } else {
            res.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    /**
     * Hiển thị form đặt lịch: nạp danh sách khoa, bác sĩ, ca khám
     */
    private void prepareAdd(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        List<Khoa> listKhoa = KhoaDAO.findAll();
        req.setAttribute("listKhoa", listKhoa);

        List<BacSi> listBacSi = BacSiDAO.findAll();
        req.setAttribute("listBacSi", listBacSi);

        // ✅ Lấy danh sách ca khám từ DB
        List<CaKham> listCaKham = new CaKhamDAO().getAllCaKham();
        req.setAttribute("listCaKham", listCaKham);

        req.getRequestDispatcher("/benhnhan/datlich.jsp").forward(req, res);
    }

    /**
     * Xử lý thêm lịch hẹn
     */
    private void themLich(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {

        HttpSession session = req.getSession(false);
        BenhNhan benhNhan;

        // ✅ Nếu chưa đăng nhập, dùng tạm ID 1 (demo)
        if (session == null || session.getAttribute("user") == null) {
            benhNhan = new BenhNhan();
            benhNhan.setId(1L);
        } else {
            benhNhan = (BenhNhan) session.getAttribute("user");
        }

            try {
                Long bacSiId = Long.valueOf(req.getParameter("bacSiId"));
                String ngayHenStr = req.getParameter("ngayHen"); // Có thể bỏ nếu không dùng nữa
                String lyDoKham = req.getParameter("lyDoKham");
                String idCaStr = req.getParameter("idCa");

                int idCa = Integer.parseInt(idCaStr);

                BacSi bacSi = BacSiDAO.findById(bacSiId);
                if (bacSi == null) {
                    req.setAttribute("error", "Bác sĩ không hợp lệ.");
                    prepareAdd(req, res);
                    return;
                }

                CaKham ca = new CaKhamDAO().getCaKhamById(idCa);
                if (ca == null) {
                    req.setAttribute("error", "Ca khám không hợp lệ.");
                    prepareAdd(req, res);
                    return;
                }

                // ✅ Lấy ngày từ CaKham
                java.util.Date ngayHen = ca.getNgay();

                LichHen lh = new LichHen();
                lh.setBenhNhan(benhNhan);
                lh.setBacSi(bacSi);
                lh.setNgayHen(ngayHen);
                lh.setLyDoKham(lyDoKham);
                lh.setChiPhi(BigDecimal.valueOf(bacSi.getChiPhiKham()));
                lh.setTrangThai("Chờ xác nhận");
                lh.setCaKham(ca); // ✅ Gắn khóa ngoại

                LichHenDAO.insert(lh);

                req.getSession().setAttribute("lichHenVuaDat", lh);
                res.sendRedirect(req.getContextPath() + "/benhnhan/xacnhan.jsp");

            } catch (Exception e) {
                e.printStackTrace();
                req.setAttribute("error", "Lỗi khi thêm lịch: " + e.getMessage());
                prepareAdd(req, res);
            }

    }

    /**
     * Hiển thị danh sách lịch hẹn của bệnh nhân
     */
    private void hienThiDanhSach(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        BenhNhan user = (BenhNhan) session.getAttribute("user");

        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        List<LichHen> lichChuaXN = LichHenDAO.findByBenhNhanAndTrangThai(user.getId(), "Chờ xác nhận");
        List<LichHen> lichDaXN = LichHenDAO.findByBenhNhanAndTrangThai(user.getId(), "Đã xác nhận");

        req.setAttribute("lichChuaXN", lichChuaXN);
        req.setAttribute("lichDaXN", lichDaXN);

        req.getRequestDispatcher("/benhnhan/lichhen.jsp").forward(req, res);
    }
    
    //==========NHAT HUY THEM==============
    
    private void assignRoomAndRedirect(HttpServletRequest req, HttpServletResponse res)
        throws ServletException, IOException {
    String lichHenIdStr = req.getParameter("lichHenId");
    if (lichHenIdStr == null || lichHenIdStr.isEmpty()) {
        // không có id -> redirect về dashboard
        res.sendRedirect(req.getContextPath() + "/benhnhan/dashboard.jsp");
        return;
    }
    int lichHenId = Integer.parseInt(lichHenIdStr);
    LichHen lichHen = LichHenDAO.getById(lichHenId);
    if (lichHen == null) {
        res.sendRedirect(req.getContextPath() + "/benhnhan/dashboard.jsp");
        return;
    }

    // Lấy thông tin để tìm phòng:
    // ưu tiên lấy khoa từ bác sĩ của lịch hẹn
    int khoaId = -1;
    if (lichHen.getBacSi() != null && lichHen.getBacSi().getKhoa() != null) {
        khoaId = lichHen.getBacSi().getKhoa().getIdKhoa();
    }
    // lấy caId
    int caId = -1;
    if (lichHen.getCaKham() != null) {
        caId = lichHen.getCaKham().getCaId();
    }

    java.util.Date ngay = lichHen.getNgayHen(); // từ LichHen.ngay (java.util.Date)

    if (khoaId == -1 || caId == -1 || ngay == null) {
        // thiếu thông tin, redirect về dashboard với thông báo (nếu bạn muốn)
        res.sendRedirect(req.getContextPath() + "/benhnhan/dashboard.jsp");
        return;
    }

    // Tìm phòng còn trống
    app.business.vatchat.PhongKham phong = app.database.PhongKhamDAO.findAvailablePhongFor(khoaId, ngay, caId);
    if (phong != null) {
        // Gọi DAO để gán phòng và mark "Đã duyệt" (bạn có method duyetLichHen)
        // duyetLichHen(int lichHenId, int idPhong, CaKham caKham)
        LichHenDAO.duyetLichHen(lichHenId, phong.getPhongId(), lichHen.getCaKham());
        // Optionally set some session message
        req.getSession().setAttribute("msg", "Đã tự động gán phòng #" + phong.getPhongId());
    } else {
        req.getSession().setAttribute("msg", "Chưa có phòng trống cho ngày/ca đã chọn. Admin sẽ xử lý.");
    }

    // Redirect về dashboard bệnh nhân
    res.sendRedirect(req.getContextPath() + "/benhnhan/dashboard.jsp");
    }
    //==================================================
}

