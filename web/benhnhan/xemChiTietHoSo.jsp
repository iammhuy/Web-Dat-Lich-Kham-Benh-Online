<%@ page import="java.sql.*, app.database.DBUtil" %>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết hồ sơ khám</title>
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
        }
        h2, h3 {
            text-align: center;
            color: #1a1a1a;
            margin-bottom: 20px;
        }
        p {
            font-size: 16px;
            color: #333;
            margin: 6px 0;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            border-radius: 8px;
            overflow: hidden;
            margin-top: 20px;
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
<%
    String hoSoIdParam = request.getParameter("hoSoId");
    if (hoSoIdParam == null) {
        out.println("<p class='empty'>Thiếu tham số <b>hoSoId</b>.</p>");
        return;
    }

    int hoSoId = Integer.parseInt(hoSoIdParam);

    // --- Kiểm tra đăng nhập ---
    Object userObj = session.getAttribute("user");
    if (userObj == null) {
        out.println("<p class='empty'>Vui lòng đăng nhập trước khi xem chi tiết hồ sơ.</p>");
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
%>
            <h2>Chi tiết hồ sơ khám</h2>
            <p><b>Hồ sơ ID:</b> <%= rs.getInt("hoSoId") %></p>
            <p><b>Lịch hẹn ID:</b> <%= rs.getInt("lichHenId") %></p>
            <p><b>Ngày khám:</b> <%= rs.getDate("ngay") %></p>
            <p><b>Lý do khám:</b> <%= rs.getString("LYDOkham") %></p>
            <p><b>Chi phí:</b> <%= rs.getDouble("CHIPHI") %> VNĐ</p>
            <p><b>Kết quả khám:</b> <%= rs.getString("ketQua") != null ? rs.getString("ketQua") : "<i>Chưa có</i>" %></p>
            <p><b>Trạng thái:</b> <%= rs.getString("TRANGTHAI") %></p>
<%
        } else {
            out.println("<p class='empty'>Không tìm thấy hồ sơ khám tương ứng hoặc bạn không có quyền xem.</p>");
            return;
        }

        rs.close();
        ps.close();

        // ======= PHẦN 2: Lấy thông tin đơn thuốc =======
        ps = conn.prepareStatement("SELECT DonThuocId, HuongDan FROM DonThuoc WHERE HoSoId = ?");
        ps.setInt(1, hoSoId);
        rs = ps.executeQuery();

        int donThuocId = -1;
        if (rs.next()) {
            donThuocId = rs.getInt("DonThuocId");
%>
            <h3>Đơn thuốc</h3>
            <p><b>Hướng dẫn sử dụng:</b> <%= rs.getString("HuongDan") %></p>
<%
        } else {
            out.println("<p class='empty'>Không có đơn thuốc cho hồ sơ này.</p>");
        }

        rs.close();
        ps.close();

        // ======= PHẦN 3: Chi tiết thuốc =======
        if (donThuocId != -1) {
            ps = conn.prepareStatement(
                "SELECT t.TenThuoc, t.CongDung, c.SoLuong, c.CachDung " +
                "FROM ChiTietDonThuoc c " +
                "JOIN Thuoc t ON c.ThuocId = t.ThuocId " +
                "WHERE c.DonThuocId = ?"
            );
            ps.setInt(1, donThuocId);
            rs = ps.executeQuery();

            boolean found = false;
            out.println("<table>");
            out.println("<tr><th>Tên thuốc</th><th>Công dụng</th><th>Số lượng</th><th>Cách dùng</th></tr>");
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
                out.println("<p class='empty'>Đơn thuốc không có chi tiết thuốc nào.</p>");
            }
        }

    } catch (Exception e) {
        out.println("<p class='empty' style='color:red'>Lỗi: " + e.getMessage() + "</p>");
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception ex) {}
        try { if (ps != null) ps.close(); } catch (Exception ex) {}
        try { if (conn != null) conn.close(); } catch (Exception ex) {}
    }
%>

    <div style="text-align:center;">
        <a href="xemLichSuKham.jsp" class="back-link">← Quay lại lịch sử khám</a>
    </div>
</div>

<footer>© 2025 Bệnh viện Đa Khoa Online | Hotline: 1900 9999</footer>
</body>
</html>
