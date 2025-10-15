<%@ page import="java.sql.*, app.database.DBUtil" %> 
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    // --- Kiểm tra đăng nhập ---
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

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch sử khám bệnh</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
        }
    </style>
</head>
<body class="bg-gray-100 min-h-screen">
<jsp:include page="/layout/header.jsp" />

<div class="container mx-auto px-4 py-8">
    <div class="bg-white shadow-md rounded-lg p-6">
        <h2 class="text-2xl font-semibold text-gray-800 mb-6 border-b pb-3">
            🩺 Lịch sử khám bệnh
        </h2>

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

                boolean any = false;
        %>

        <table class="min-w-full border border-gray-200 rounded-lg overflow-hidden shadow-sm">
            <thead class="bg-gray-50">
                <tr>
                    <th class="py-3 px-4 text-left text-sm font-semibold text-gray-600">Hồ sơ ID</th>
                    <th class="py-3 px-4 text-left text-sm font-semibold text-gray-600">Lịch hẹn ID</th>
                    <th class="py-3 px-4 text-left text-sm font-semibold text-gray-600">Ngày khám</th>
                    <th class="py-3 px-4 text-left text-sm font-semibold text-gray-600">Kết quả</th>
                    <th class="py-3 px-4 text-center text-sm font-semibold text-gray-600">Hành động</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-gray-200">
                <%
                    while (rs.next()) {
                        any = true;
                %>
                <tr class="hover:bg-gray-50 transition">
                    <td class="py-3 px-4 text-gray-700"><%= rs.getInt("hoSoId") %></td>
                    <td class="py-3 px-4 text-gray-700"><%= rs.getInt("lichHenId") %></td>
                    <td class="py-3 px-4 text-gray-700"><%= rs.getDate("ngay") %></td>
                    <td class="py-3 px-4 text-gray-700">
                        <%= (rs.getString("ketQua") != null ? rs.getString("ketQua") : "Chưa có") %>
                    </td>
                    <td class="py-3 px-4 text-center">
                        <a href="xemChiTietHoSo.jsp?action=view&hoSoId=<%= rs.getInt("hoSoId") %>"
                           class="text-blue-600 hover:text-blue-800 font-medium transition">Xem chi tiết</a>
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>

        <%
                if (!any) {
                    out.println("<p class='mt-6 text-gray-600 italic'>Chưa có hồ sơ khám nào với trạng thái 'Đã xác nhận'.</p>");
                }
            } catch (Exception e) {
                out.println("<p class='text-red-600 mt-6'>Lỗi khi tải dữ liệu: " + e.getMessage() + "</p>");
                e.printStackTrace(System.out);
            } finally {
                DBUtil.closeResultSet(rs);
                DBUtil.closePreparedStatement(ps);
                DBUtil.closeConnection(conn);
            }
        %>
    </div>

    <div class="mt-8 text-center">
        <a href="${pageContext.request.contextPath}/benhnhan/dashboard.jsp"
           class="inline-block bg-blue-600 hover:bg-blue-700 text-white px-5 py-2 rounded-lg shadow transition">
           Quay lại bảng điều khiển
        </a>
    </div>
</div>

<jsp:include page="/layout/footer.jsp" />
</body>
</html>
