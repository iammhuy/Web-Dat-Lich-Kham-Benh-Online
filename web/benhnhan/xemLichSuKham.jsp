<%@ page import="java.sql.*, app.database.DBUtil" %> 
<%@ page contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <title>Lịch sử khám</title>
</head>
<body>
<%
    // --- Lấy user từ session ---
    Object userObj = session.getAttribute("user");
    if (userObj == null) {
        out.println("<p>Vui lòng đăng nhập trước khi xem lịch sử khám.</p>");
        return;
    }

    Long userIdObj = null;
    try {
        java.lang.reflect.Method m = userObj.getClass().getMethod("getUserId");
        userIdObj = (Long) m.invoke(userObj);
    } catch (NoSuchMethodException ex) {
        try {
            java.lang.reflect.Method m = userObj.getClass().getMethod("getId");
            userIdObj = (Long) m.invoke(userObj);
        } catch (Exception e) {
            out.println("<p style='color:red'>Không thể lấy mã người dùng.</p>");
            return;
        }
    }

    if (userIdObj == null) {
        out.println("<p style='color:red'>Không thể xác định người dùng hiện tại.</p>");
        return;
    }
    int userId = userIdObj.intValue();
%>

<h2>Lịch sử khám bệnh</h2>

<%
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = DBUtil.getConnection();

        // --- CHỈ LẤY HỒ SƠ KHÁM TỪ CÁC LỊCH ĐÃ XÁC NHẬN ---
        ps = conn.prepareStatement(
            "SELECT h.hoSoId, l.lichHenId, l.ngay, h.ketQua " +
            "FROM HoSoKham h " +
            "JOIN LichHen l ON h.lichHenId = l.lichHenId " +
            "WHERE l.idBenhNhan = ? AND l.TRANGTHAI = 'Đã xác nhận' " +
            "ORDER BY l.ngay DESC"
        );
        ps.setInt(1, userId);
        rs = ps.executeQuery();

        out.println("<table border='1' cellpadding='8' cellspacing='0'>");
        out.println("<tr><th>Hồ sơ ID</th><th>Lịch hẹn ID</th><th>Ngày khám</th><th>Kết quả</th><th>Hành động</th></tr>");

        boolean any = false;
        while (rs.next()) {
            any = true;
            out.println("<tr>");
            out.println("<td>" + rs.getInt("hoSoId") + "</td>");
            out.println("<td>" + rs.getInt("lichHenId") + "</td>");
            out.println("<td>" + rs.getDate("ngay") + "</td>");
            out.println("<td>" + (rs.getString("ketQua") != null ? rs.getString("ketQua") : "Chưa có") + "</td>");
            out.println("<td><a href='xemChiTietHoSo.jsp?action=view&hoSoId=" + rs.getInt("hoSoId") + "'>Xem chi tiết</a></td>");
            out.println("</tr>");
        }
        out.println("</table>");

        if (!any) {
            out.println("<p>Chưa có hồ sơ khám nào với trạng thái 'Đã xác nhận'.</p>");
        }

    } catch (Exception e) {
        out.println("<p style='color:red'>Lỗi khi tải dữ liệu: " + e.getMessage() + "</p>");
        e.printStackTrace(System.out);
    } finally {
        DBUtil.closeResultSet(rs);
        DBUtil.closePreparedStatement(ps);
        DBUtil.closeConnection(conn);
    }
%>

</body>
</html>
