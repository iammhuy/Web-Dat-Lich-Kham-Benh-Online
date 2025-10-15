package app.controller;

import app.business.hosokham.DonThuoc;
import app.business.hosokham.ChiTietDonThuoc;
import app.database.DonThuocDAO;
import app.database.ChiTietDonThuocDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "DonThuocController", urlPatterns = {"/donthuoc"})
public class DonThuocController extends HttpServlet {
    private DonThuocDAO dtDao = new DonThuocDAO();
    private ChiTietDonThuocDAO ctDao = new ChiTietDonThuocDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if("add".equals(action)) {
            // mở trang thêm đơn thuốc với hoSoId param
            req.getRequestDispatcher("/themDonThuoc.jsp").forward(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath());
        }
    }

    // Thêm don thuoc (tạo donThuoc mới) hoặc add chi tiết thuốc
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if("createDon".equals(action)) {
            String hoSoIdS = req.getParameter("hoSoId");
            String huongDan = req.getParameter("huongDan");
            DonThuoc d = new DonThuoc();
            d.setHoSoId(Integer.parseInt(hoSoIdS));
            d.setHuongDan(huongDan);
            DonThuoc saved = dtDao.create(d);
            // chuyển lại trang themDonThuoc để thêm chi tiết, kèm donThuocId
            resp.sendRedirect(req.getContextPath() + "/donthuoc?action=add&hoSoId=" + hoSoIdS + "&donThuocId=" + saved.getDonThuocId());
        } else if("addItem".equals(action)) {
            String donThuocIdS = req.getParameter("donThuocId");
            String thuocIdS = req.getParameter("thuocId");
            String soLuongS = req.getParameter("soLuong");
            String cachDung = req.getParameter("cachDung");

            ChiTietDonThuoc ct = new ChiTietDonThuoc();
            ct.setDonThuocId(Integer.parseInt(donThuocIdS));
            ct.setThuocId(Integer.parseInt(thuocIdS));
            ct.setSoLuong(Integer.parseInt(soLuongS));
            ct.setCachDung(cachDung);
            ctDao.create(ct);

            // trở lại trang themDonThuoc với donThuocId để hiển thị danh sách cập nhật
            String hoSoId = req.getParameter("hoSoId");
            resp.sendRedirect(req.getContextPath() + "/donthuoc?action=add&hoSoId=" + hoSoId + "&donThuocId=" + donThuocIdS);
        } else if("finish".equals(action)) {
            // hoàn tất và trở về danh sách lịch sử
            String hoSoId = req.getParameter("hoSoId");
            resp.sendRedirect(req.getContextPath() + "/hosokham?action=history");
        }
    }
}
