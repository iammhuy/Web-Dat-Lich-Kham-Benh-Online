<%@ page import="java.sql.*, java.util.*, app.database.DBUtil" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <title>Thêm Đơn Thuốc</title>
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
            text-align: center;
            padding: 14px 0;
            font-size: 20px;
            font-weight: bold;
        }
        .container {
            max-width: 900px;
            margin: 40px auto;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            padding: 30px;
        }
        h2 {
            text-align: center;
            color: #1a1a1a;
            margin-bottom: 25px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
            border-radius: 8px;
            overflow: hidden;
        }
        th {
            background-color: #1a73e8;
            color: white;
            padding: 10px;
        }
        td {
            border-bottom: 1px solid #ddd;
            padding: 10px;
        }
        input, textarea {
            width: 100%;
            padding: 8px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }
        button {
            background-color: #1a73e8;
            color: white;
            border: none;
            border-radius: 8px;
            padding: 10px 18px;
            margin-top: 15px;
            cursor: pointer;
            font-weight: 500;
        }
        button:hover {
            background-color: #145dc0;
        }
        .err { color: red; }
        .ok { color: green; }
        a {
            color: #1a73e8;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
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
    <script>
        function addRow() {
            const table = document.getElementById("thuocTable").getElementsByTagName("tbody")[0];
            const row = table.insertRow();
            const stt = table.rows.length;
            row.innerHTML = `
                <td>${stt}</td>
                <td><input name="thuocId" type="number" onchange="loadThuocInfo(this)" required></td>
                <td><input name="tenThuoc" type="text" readonly></td>
                <td><input name="congDung" type="text" readonly></td>
                <td><input name="soLuong" type="number" required></td>
                <td><input name="cachDung" type="text" required></td>
            `;
        }

        async function loadThuocInfo(input) {
            const thuocId = input.value;
            const row = input.closest("tr");
            if (!thuocId) return;
            const response = await fetch('getThuocInfo.jsp?thuocId=' + thuocId);
            const text = await response.text();
            try {
                const data = JSON.parse(text);
                row.querySelector('input[name="tenThuoc"]').value = data.tenThuoc || '';
                row.querySelector('input[name="congDung"]').value = data.congDung || '';
            } catch {
                alert("Không tìm thấy thông tin thuốc ID = " + thuocId);
            }
        }
    </script>
</head>
<body>
<header>BV Đa Khoa Online</header>

<div class="container">
    <h2>Thêm Đơn Thuốc Cho Hồ Sơ Khám</h2>

<%
String err = null;
String ok = null;
String hoSoIdStr = request.getParameter("hoSoId");
if (hoSoIdStr == null) {
    err = "Thiếu tham số hoSoId!";
} else {
    int hoSoId = Integer.parseInt(hoSoIdStr);

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String[] thuocIds = request.getParameterValues("thuocId");
        String[] soLuongs = request.getParameterValues("soLuong");
        String[] cachDungs = request.getParameterValues("cachDung");
        String huongDan = request.getParameter("huongDan");

        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);

            int donThuocId = -1;
            try (PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO DonThuoc (HoSoId, HuongDan) VALUES (?, ?)", Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, hoSoId);
                ps.setString(2, huongDan);
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) donThuocId = rs.getInt(1);
                }
            }

            if (donThuocId > 0 && thuocIds != null) {
                try (PreparedStatement ps2 = conn.prepareStatement(
                    "INSERT INTO ChiTietDonThuoc (DonThuocId, ThuocId, SoLuong, CachDung) VALUES (?, ?, ?, ?)")) {
                    for (int i = 0; i < thuocIds.length; i++) {
                        ps2.setInt(1, donThuocId);
                        ps2.setInt(2, Integer.parseInt(thuocIds[i]));
                        ps2.setInt(3, Integer.parseInt(soLuongs[i]));
                        ps2.setString(4, cachDungs[i]);
                        ps2.addBatch();
                    }
                    ps2.executeBatch();
                }
            }

            conn.commit();
            ok = "Tạo đơn thuốc thành công cho hồ sơ ID = " + hoSoId;
        } catch (Exception e) {
            err = "Lỗi khi lưu đơn thuốc: " + e.getMessage();
            e.printStackTrace();
        }
    }
}
%>

<% if (err != null) { %>
    <p class="err"><%= err %></p>
<% } else if (ok != null) { %>
    <p class="ok"><%= ok %></p>
    <div style="text-align:center;">
        <a href="index.jsp" class="back-link">← Quay lại trang chính</a>
    </div>
<% } else if (hoSoIdStr != null) { %>

<form method="post" action="themDonThuoc.jsp?hoSoId=<%=hoSoIdStr%>">
    <table id="thuocTable">
        <thead>
        <tr>
            <th>STT</th>
            <th>Thuốc ID</th>
            <th>Tên Thuốc</th>
            <th>Công Dụng</th>
            <th>Số Lượng</th>
            <th>Cách Dùng</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td>1</td>
            <td><input name="thuocId" type="number" onchange="loadThuocInfo(this)" required></td>
            <td><input name="tenThuoc" type="text" readonly></td>
            <td><input name="congDung" type="text" readonly></td>
            <td><input name="soLuong" type="number" required></td>
            <td><input name="cachDung" type="text" required></td>
        </tr>
        </tbody>
    </table>
    <button type="button" onclick="addRow()">+ Thêm thuốc</button>

    <h3>Hướng dẫn bác sĩ</h3>
    <textarea name="huongDan" rows="4" required></textarea>

    <button type="submit">Xác nhận đơn thuốc</button>
</form>

<div style="text-align:center;">
    <a href="index.jsp" class="back-link">← Quay lại trang chính</a>
</div>

<% } %>

</div>

<footer>© 2025 Bệnh viện Đa Khoa Online | Hotline: 1900 9999</footer>
</body>
</html>
