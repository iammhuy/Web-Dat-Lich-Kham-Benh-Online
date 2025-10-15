<%@ page import="java.sql.*, app.database.DBUtil" %> 
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch sử khám bệnh</title>
    <link rel="stylesheet" href="../assets/styles/main.css">
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f4f6f8;
            margin: 0;
            padding: 0;
        }
        header {
            background-color: #1a73e8;
            color: white;
            padding: 14px 0;
            text-align: center;
            font-weight: bold;
            font-size: 20px;
        }
        .container {
            max-width: 900px;
            margin: 40px auto;
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            padding: 30px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }
        h2 {
            text-align: center;
            color: #1a1a1a;
            margin-bottom: 25px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            border-radius: 8px;
            overflow: hidden;
        }
        th {
            background-color: #1a73e8;
            color: white;
            padding: 10px;
            text-align: left;
        }
        td {
            padding: 10px;
            border-bottom: 1px solid #ddd;
        }
        tr:hover {
            background-color: #f1f7ff;
        }
        a {
            color: #1a73e8;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
        .empty {
            text-align: center;
            color: #666;
            margin-top: 15px;
        }
        .back-link {
            display: inline-block;
            margin-top: 25px;
            text-decoration: none;
            color: white;
            background-color: #1a73e8;
            padding: 8px 18px;
            border-radius: 8px;
            font-weight: 500;
        }
        .back-link:hover {
            background-color: #145dc0;
        }
        footer {
            text-align: center;
            margin-top: 40px;
            color: #777;
            font-size: 14px;
        }
    </style>
</head>
<body>
<header>BV Đa Khoa Online</header>

<div class="container">
    <h2>Lịch sử khám bệnh</h2>

<%
    Object userObj = session.getAttribute("user");
    if (userObj == null) {
        out.println("<p class='empty'>Vui lòng đăng nhập trước khi xem lịch sử khám.</p>");
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
            out.println("<p class='empty'>Không thể lấy mã người dùng.</p>");
            return;
        }
    }

    if (userIdObj == null) {
        out.println("<p class='empty'>Không thể xác định người dùng hiện tại.</p>");
        return;
    }
    int userId = userIdObj.intValue();

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = DBUtil.getConnection();
        ps = conn.prepareStatement(
            "SELECT h.hoSoId, l.lichHenId, l.ngay, h.ketQua " +
            "FROM HoSoKham h " +
            "JOIN LichHen l ON h.lichHenId = l.lichHenId " +
            "WHERE l.idBenhNhan = ? AND l.TRANGTHAI = 'Đã xác nhận' " +
            "ORDER BY l.ngay DESC"
        );
        ps.setInt(1, userId);
        rs = ps.executeQuery();

        boolean any = false;
        out.println("<table>");
        out.println("<tr><th>Hồ sơ ID</th><th>Lịch hẹn ID</th><th>Ngày khám</th><th>Kết quả</th><th>Hành động</th></tr>");
        while (rs.next()) {
            any = true;
            out.println("<tr>");
            out.println("<td>" + rs.getInt("hoSoId") + "</td>");
            out.println("<td>" + rs.getInt("lichHenId") + "</td>");
            out.println("<td>" + rs.getDate("ngay") + "</td>");
            out.println("<td>" + (rs.getString("ketQua") != null ? rs.getString("ketQua") : "<i>Chưa có</i>") + "</td>");
            out.println("<td><a href='xemChiTietHoSo.jsp?hoSoId=" + rs.getInt("hoSoId") + "'>Xem chi tiết</a></td>");
            out.println("</tr>");
        }
        out.println("</table>");

        if (!any) {
            out.println("<p class='empty'>Chưa có hồ sơ khám nào được xác nhận.</p>");
        }

        // ✅ Thêm nút quay lại Dashboard
        out.println("<div style='text-align:center; width:100%;'>");
        out.println("<a href=\"dashboard.jsp\" class=\"back-link\">← Quay lại trang chính</a>");
        out.println("</div>");

    } catch (Exception e) {
        out.println("<p class='empty' style='color:red'>Lỗi khi tải dữ liệu: " + e.getMessage() + "</p>");
    } finally {
        DBUtil.closeResultSet(rs);
        DBUtil.closePreparedStatement(ps);
        DBUtil.closeConnection(conn);
    }
%>
</div>

    <!-- Footer/logo chung -->
    <footer class="bg-blue-600 text-white text-center py-3 text-sm">
        © 2025 Bệnh viện Đa Khoa Online | Hotline: 1900 9999
    </footer>
</body>
</html>