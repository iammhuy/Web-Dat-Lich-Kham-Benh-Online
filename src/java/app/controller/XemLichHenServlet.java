package app.controller;

import app.business.giaodich.LichHen;
import app.database.LichHenDAO;
import app.business.nguoidung.BenhNhan;
import app.database.PhongKhamDAO;
import javax.servlet.http.HttpSession;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/xem-lich-hen")
public class XemLichHenServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Kiểm tra xem URL có chứa tham số 'lichHenId' không
        String lichHenIdStr = request.getParameter("lichHenId");

        if (lichHenIdStr != null && !lichHenIdStr.isEmpty()) {
            // TRƯỜNG HỢP 1: CÓ ID -> Gọi phương thức hiển thị chi tiết
            showLichHenChiTiet(request, response, lichHenIdStr);
        } else {
            // TRƯỜNG HỢP 2: KHÔNG CÓ ID -> Gọi phương thức hiển thị danh sách
            showDanhSachLichHen(request, response);
        }
       
    }
     private void showDanhSachLichHen(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        BenhNhan benhNhan = (BenhNhan) session.getAttribute("user");

        if (benhNhan == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            // This is your original logic for getting the list
            List<LichHen> dsLichHen = LichHenDAO.findAllByBenhNhan(benhNhan.getUserId());
            request.setAttribute("dsLichHen", dsLichHen);
            // Forward to the LIST page
            request.getRequestDispatcher("/benhnhan/chitiet_lichhen.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi tải danh sách lịch hẹn!");
            request.getRequestDispatcher("/benhnhan/dashboard.jsp").forward(request, response);
        }
    }

    private void showLichHenChiTiet(HttpServletRequest request, HttpServletResponse response, String lichHenIdStr)
            throws ServletException, IOException {
        try {
            int lichHenId = Integer.parseInt(lichHenIdStr);
            LichHen lichHen = LichHenDAO.getById(lichHenId);
            
            if (lichHen != null) {
                request.setAttribute("lichHen", lichHen);
                String tenPhong = app.database.PhongKhamDAO.getTenPhongById(lichHen.getIdPhong());
                request.setAttribute("tenPhong", tenPhong);
                // Forward to the DETAIL page
                request.getRequestDispatcher("/benhnhan/hienthichitiet.jsp").forward(request, response);
            } else {
                // Handle case where ID is not found
                request.setAttribute("errorMessage", "Không tìm thấy lịch hẹn.");
                request.getRequestDispatcher("/benhnhan/chitiet_lichhen.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "ID lịch hẹn không hợp lệ.");
            // Redirect back to the list view on error
            response.sendRedirect(request.getContextPath() + "/xem-lich-hen");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
