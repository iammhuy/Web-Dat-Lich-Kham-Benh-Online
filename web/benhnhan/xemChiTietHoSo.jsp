<%@ page import="java.sql.*, app.database.DBUtil" %> 
<%@ page contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <title>Chi tiết hồ sơ khám</title>
</head>
<body>
<%
    // --- Lấy ID hồ sơ từ request ---
    String hoSoIdParam = request.getParameter("hoSoId");
    if (hoSoIdParam == null) {
        out.println("<p>Thiếu tham số hoSoId.</p>");
        return;
    }

    int hoSoId = Integer.parseInt(hoSoIdParam);

    // --- Kiểm tra đăng nhập ---
    Long userIdObj = (Long) session.getAttribute("userId");
    if (userIdObj == null) {
        out.println("<p>Vui lòng đăng nhập trước khi xem chi tiết hồ sơ.</p>");
        return;
    }
    int userId = userIdObj.intValue();

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = DBUtil.getConnection();

        // ======= PHẦN 1: Lấy thông tin hồ sơ + lịch hẹn =======
        ps = conn.prepareStatement(
            "SELECT h.hoSoId, l.lichHenId, l.ngay, h.ketQua, l.LYDOkham, l.CHIPHI, l.TRANGTHAI " +
            "FROM HoSoKham h " +
            "JOIN LichHen l ON h.lichHenId = l.lichHenId " +
            "WHERE h.hoSoId = ? AND l.idBenhNhan = ?"
        );
        ps.setInt(1, hoSoId);
        ps.setInt(2, userId);
        rs = ps.executeQuery();

        if (rs.next()) {
            out.println("<h2>Chi tiết hồ sơ khám</h2>");
            out.println("<p><b>Hồ sơ ID:</b> " + rs.getInt("hoSoId") + "</p>");
            out.println("<p><b>Lịch hẹn ID:</b> " + rs.getInt("lichHenId") + "</p>");
            out.println("<p><b>Ngày khám:</b> " + rs.getDate("ngay") + "</p>");
            out.println("<p><b>Lý do khám:</b> " + rs.getString("LYDOkham") + "</p>");
            out.println("<p><b>Chi phí:</b> " + rs.getDouble("CHIPHI") + "</p>");
            out.println("<p><b>Kết quả khám:</b> " + rs.getString("ketQua") + "</p>");
            out.println("<p><b>Trạng thái:</b> " + rs.getString("TRANGTHAI") + "</p>");
        } else {
            out.println("<p>Không tìm thấy hồ sơ khám tương ứng hoặc bạn không có quyền xem.</p>");
            return;
        }
        rs.close();
        ps.close();

        // ======= PHẦN 2: Lấy thông tin đơn thuốc =======
        ps = conn.prepareStatement(
            "SELECT DonThuocId, HuongDan FROM DonThuoc WHERE HoSoId = ?"
        );
        ps.setInt(1, hoSoId);
        rs = ps.executeQuery();

        int donThuocId = -1;
        if (rs.next()) {
            donThuocId = rs.getInt("DonThuocId");
            out.println("<h3>Đơn thuốc</h3>");
            out.println("<p><b>Hướng dẫn:</b> " + rs.getString("HuongDan") + "</p>");
        } else {
            out.println("<p>Không có đơn thuốc cho hồ sơ này.</p>");
        }
        rs.close();
        ps.close();

        // ======= PHẦN 3: Chi tiết thuốc trong đơn =======
        if (donThuocId != -1) {
            ps = conn.prepareStatement(
                "SELECT t.TenThuoc, t.CongDung, c.SoLuong, c.CachDung " +
                "FROM ChiTietDonThuoc c " +
                "JOIN Thuoc t ON c.ThuocId = t.ThuocId " +
                "WHERE c.DonThuocId = ?"
            );
            ps.setInt(1, donThuocId);
            rs = ps.executeQuery();

            out.println("<table border='1' cellpadding='8' cellspacing='0'>");
            out.println("<tr><th>Tên thuốc</th><th>Công dụng</th><th>Số lượng</th><th>Cách dùng</th></tr>");
            boolean found = false;
            while (rs.next()) {
                found = true;
                out.println("<tr>");
                out.println("<td>" + rs.getString("TenThuoc") + "</td>");
                out.println("<td>" + rs.getString("CongDung") + "</td>");
                out.println("<td>" + rs.getInt("SoLuong") + "</td>");
                out.println("<td>" + rs.getString("CachDung") + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
            if (!found) {
                out.println("<p>Đơn thuốc không có chi tiết thuốc nào.</p>");
            }
        }

    } catch (Exception e) {
        out.println("<p style='color:red'>Lỗi: " + e.getMessage() + "</p>");
        e.printStackTrace(System.out);
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception ex) {}
        try { if (ps != null) ps.close(); } catch (Exception ex) {}
        try { if (conn != null) conn.close(); } catch (Exception ex) {}
    }
%>

<p><a href="xemLichSuKham.jsp">Quay lại lịch sử khám</a></p>
</body>
</html>
