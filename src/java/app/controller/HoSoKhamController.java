package app.controller;

import app.business.hosokham.HoSoKham;
import app.database.HoSoKhamDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "HoSoKhamController", urlPatterns = {"/hosokham"})
public class HoSoKhamController extends HttpServlet {
    private HoSoKhamDAO hsDao = new HoSoKhamDAO();

    // hiển thị form tạo hồ sơ
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if("create".equals(action)) {
            // lấy danh sách lichhen để chọn -> ta dùng native query trong JSP (scriptlet) nếu cần
            req.getRequestDispatcher("bacsi/taoHoSoKham.jsp").forward(req, resp);
        } else if("history".equals(action)) {
            // bệnh nhân xem lịch sử (userId lấy từ session)
            req.getRequestDispatcher("/xemLichSuKham.jsp").forward(req, resp);
        } else if("view".equals(action)) {
            req.getRequestDispatcher("/xemChiTietHoSo.jsp").forward(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath());
        }
    }

    // lưu ho so va chuyển sang thêm don thuoc
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("save".equals(action)) {
    try {
        String lichHenIdS = req.getParameter("lichHenId");
        String ketQua = req.getParameter("ketQua");
        Integer lichHenId = Integer.parseInt(lichHenIdS);

        HoSoKham hs = new HoSoKham();
        hs.setLichHenId(lichHenId);
        hs.setKetQua(ketQua);

        HoSoKham saved = hsDao.create(hs);
        if (saved == null) {
            throw new Exception("Không thể lưu hồ sơ khám. hsDao.create(hs) trả về null");
        }

        resp.sendRedirect(req.getContextPath() + "/donthuoc?action=add&hoSoId=" + saved.getHoSoId());
    } catch (Exception e) {
        e.printStackTrace();
        req.setAttribute("error", "Lỗi khi lưu hồ sơ khám: " + e.getMessage());
        req.getRequestDispatcher("/bacsi/taoHoSoKham.jsp").forward(req, resp);
    }
        } else if("update".equals(action)) {
            String hoSoIdS = req.getParameter("hoSoId");
            String ketQua = req.getParameter("ketQua");
            HoSoKham hs = hsDao.findById(Integer.parseInt(hoSoIdS));
            if(hs != null) {
                hs.setKetQua(ketQua);
                hsDao.update(hs);
            }
            resp.sendRedirect(req.getContextPath() + "/hosokham?action=history");
        }
    }
}
