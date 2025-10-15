package app.controller;

import app.business.hosokham.HoSoKham;
import app.database.HoSoKhamDAO;
import app.database.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.List;

@WebServlet(name = "HoSoKhamController", urlPatterns = {"/hosokham"})
public class HoSoKhamController extends HttpServlet {

    private HoSoKhamDAO dao = new HoSoKhamDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");

        if (action == null) {
            req.getRequestDispatcher("/bacsi/index.jsp").forward(req, resp);
            return;
        }

        switch (action) {
            case "create":
                req.getRequestDispatcher("/bacsi/taoHoSo.jsp").forward(req, resp);
                break;

            case "history":
                // lịch sử cho bệnh nhân (đã có)
                req.getRequestDispatcher("/benhnhan/xemChiTietHoSo.jsp").forward(req, resp);
                break;

            case "viewByDoctor":
                // ✅ bác sĩ xem lịch sử khám của bệnh nhân
                try {
                    String idParam = req.getParameter("idBenhNhan");
                    if (idParam == null || idParam.isEmpty()) {
                        req.setAttribute("error", "Thiếu idBenhNhan để xem lịch sử.");
                        req.getRequestDispatcher("/bacsi/index.jsp").forward(req, resp);
                        return;
                    }

                    long idBenhNhan = Long.parseLong(idParam);
                    List<HoSoKham> list = dao.findByBenhNhanId(idBenhNhan);

                    req.setAttribute("hoSoList", list);
                    req.setAttribute("idBenhNhan", idBenhNhan);

                    // ✅ forward sang trang hiển thị lịch sử (bác sĩ)
                    req.getRequestDispatcher("/bacsi/xemLichSuKham.jsp").forward(req, resp);

                } catch (Exception ex) {
                    ex.printStackTrace();
                    req.setAttribute("error", "Lỗi khi tải lịch sử khám: " + ex.getMessage());
                    req.getRequestDispatcher("/bacsi/index.jsp").forward(req, resp);
                }
                break;

            default:
                resp.sendRedirect(req.getContextPath() + "/bacsi/index.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("save".equals(action)) {
            try {
                int lichHenId = Integer.parseInt(req.getParameter("lichHenId"));
                String ketQua = req.getParameter("ketQua");

                HoSoKham hoSo = new HoSoKham();
                hoSo.setLichHenId(lichHenId);
                hoSo.setKetQua(ketQua);
                hoSo.setChuanDoan("Tổng quát");

                HoSoKham saved = dao.create(hoSo);
                if (saved == null || saved.getHoSoId() == 0) {
                    req.setAttribute("error", "Không thể tạo hồ sơ khám!");
                    req.getRequestDispatcher("/bacsi/taoHoSo.jsp").forward(req, resp);
                    return;
                }

                // Cập nhật trạng thái lịch hẹn
                try (Connection conn = DBUtil.getConnection()) {
                    PreparedStatement ps = conn.prepareStatement(
                        "UPDATE LichHen SET TRANGTHAI = 'Đã xác nhận' WHERE LichHenId = ?");
                    ps.setInt(1, lichHenId);
                    ps.executeUpdate();
                }

                // ✅ Sau khi tạo hồ sơ → chuyển sang trang thêm đơn thuốc
                resp.sendRedirect(req.getContextPath()
                    + "/bacsi/themDonThuoc.jsp?hoSoId=" + saved.getHoSoId());

            } catch (Exception e) {
                e.printStackTrace();
                req.setAttribute("error", "Lỗi khi lưu hồ sơ khám: " + e.getMessage());
                req.getRequestDispatcher("/bacsi/taoHoSo.jsp").forward(req, resp);
            }
        }
    }
}
