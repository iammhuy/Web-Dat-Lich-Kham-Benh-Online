<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="app.business.giaodich.LichHen, java.util.List, java.text.SimpleDateFormat" %>

<%
    List<LichHen> dsLichHen = (List<LichHen>) request.getAttribute("dsLichHen");
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Danh sách lịch hẹn</title>
<script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 p-6">

<div class="max-w-5xl mx-auto bg-white p-6 rounded shadow-md">
    <h1 class="text-2xl font-bold mb-4">Danh sách lịch hẹn của tôi</h1>

    <table class="w-full border text-left">
        <thead class="bg-gray-100">
            <tr>
                <th class="p-2 border">ID</th>
                <th class="p-2 border">Ngày hẹn</th>
                <th class="p-2 border">Trạng thái</th>
                <th class="p-2 border">Bác sĩ</th>
                <th class="p-2 border">Chi tiết</th>
            </tr>
        </thead>
        <tbody>
        <%
            if (dsLichHen != null) {
                for (LichHen lh : dsLichHen) {
        %>
            <tr>
                <td class="p-2 border"><%= lh.getLichHenId() %></td>
                <td class="p-2 border"><%= dateFormat.format(lh.getNgayHen()) %></td>
                <td class="p-2 border"><%= lh.getTrangThai() %></td>
                <td class="p-2 border"><%= lh.getBacSi().getLastName() %> <%= lh.getBacSi().getFirstName() %></td>
                <td class="p-2 border text-center">
                    <a href="${pageContext.request.contextPath}/xem-lich-hen?lichHenId=<%= lh.getLichHenId() %>"
                       class="text-blue-600 hover:underline">Xem chi tiết</a>
                </td>
            </tr>
        <%
                }
            } else {
        %>
            <tr><td colspan="5" class="p-2 border text-center">Chưa có lịch hẹn nào.</td></tr>
        <%
            }
        %>
        </tbody>
    </table>

    <div class="mt-6">
        <a href="${pageContext.request.contextPath}/benhnhan/dashboard.jsp"
           class="px-4 py-2 bg-gray-600 text-white rounded hover:bg-gray-700">
           ← Quay lại Dashboard
        </a>
    </div>
</div>

</body>
</html>
