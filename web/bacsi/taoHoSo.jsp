<%@ page import="java.sql.*, app.database.DBUtil" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>
    <title>Tạo Hồ Sơ Khám</title>
    <style>
        body {
            font-family: "Segoe UI", Arial, sans-serif;
            background-color: #f5f6fa;
            margin: 0;
            padding: 30px;
        }

        h2 {
            color: #2d3436;
            margin-bottom: 20px;
        }

        form {
            margin-bottom: 20px;
        }

        label {
            font-weight: 600;
            display: block;
            margin-top: 10px;
            margin-bottom: 4px;
            color: #2d3436;
        }

        input, textarea, select {
            width: 420px;
            padding: 8px 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
            box-sizing: border-box;
            font-size: 14px;
            transition: border-color 0.2s;
        }

        input:focus, textarea:focus, select:focus {
            border-color: #0984e3;
            outline: none;
        }

        button {
            margin-top: 15px;
            padding: 8px 16px;
            border: none;
            border-radius: 6px;
            background-color: #0984e3;
            color: white;
            font-size: 14px;
            cursor: pointer;
            transition: background-color 0.2s;
        }

        button:hover {
            background-color: #0073d0;
        }

        a {
            margin-left: 12px;
            color: #636e72;
            text-decoration: none;
            font-size: 14px;
        }

        a:hover {
            text-decoration: underline;
        }

        .info {
            margin-top: 20px;
            padding: 20px;
            border: 1px solid #dfe6e9;
            background-color: #ffffff;
            border-radius: 8px;
            width: 680px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .info h4 {
            margin-top: 0;
            color: #0984e3;
            border-bottom: 1px solid #dcdde1;
            padding-bottom: 6px;
        }

        .info p {
            margin: 6px 0;
            line-height: 1.5;
        }

        .err {
            color: #d63031;
            font-weight: bold;
        }

        .ok {
            color: #00b894;
            font-weight: bold;
        }
    </style>
</head>
<body>
<h2>Tạo Hồ Sơ Khám</h2>

<% String msg = null; String err = null; %>

<%
String method = request.getMethod();
String lichHenIdParam = request.getParameter("lichHenId");

if ("POST".equalsIgnoreCase(method) && request.getParameter("action") != null && "save".equals(request.getParameter("action"))) {
    String lichHenIdS = request.getParameter("lichHenId");
    String ketQua = request.getParameter("ketQua");
    if (lichHenIdS == null || lichHenIdS.trim().isEmpty()) {
        err = "Bạn phải nhập LichHenId.";
    } else {
        try (Connection conn = DBUtil.getConnection()) {
            int lichHenId = Integer.parseInt(lichHenIdS);
            try (PreparedStatement q = conn.prepareStatement("SELECT lichHenId FROM LichHen WHERE lichHenId = ?")) {
                q.setInt(1, lichHenId);
                try (ResultSet r = q.executeQuery()) {
                    if (!r.next()) {
                        err = "Không tìm thấy LichHenId = " + lichHenId;
                    } else {
                        try (PreparedStatement ins = conn.prepareStatement(
                                "INSERT INTO HoSoKham (LichHenId, KetQua) VALUES (?, ?)", Statement.RETURN_GENERATED_KEYS)) {
                            ins.setInt(1, lichHenId);
                            ins.setString(2, ketQua);
                            int affected = ins.executeUpdate();
                            if (affected == 0) {
                                err = "Không thể tạo hồ sơ (không có dòng được insert).";
                            } else {
                                int newHoSoId = -1;
                                try (ResultSet gk = ins.getGeneratedKeys()) {
                                    if (gk.next()) newHoSoId = gk.getInt(1);
                                }
                                if (newHoSoId == -1) {
                                    err = "Tạo hồ sơ thành công nhưng không lấy được ID.";
                                } else {
                                    try (PreparedStatement up = conn.prepareStatement(
                                            "UPDATE LichHen SET TRANGTHAI = 'Đã xác nhận' WHERE lichHenId = ?")) {
                                        up.setInt(1, lichHenId);
                                        up.executeUpdate();
                                    }
                                    response.sendRedirect(request.getContextPath() + "/bacsi/themDonThuoc.jsp?hoSoId=" + newHoSoId);
                                    return;
                                }
                            }
                        }
                    }
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            err = "Lỗi khi tạo hồ sơ: " + ex.getMessage();
        }
    }
}

Integer showLichHenId = null;
ResultSet rs = null;
if (lichHenIdParam != null && !lichHenIdParam.trim().isEmpty()) {
    try (Connection conn = DBUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement("SELECT lichHenId, idBenhNhan, idBacSi, idPhong, idCa, NGAYHEN, timeStart, timeEnd, CHIPHI, LYDOKHAM, TRANGTHAI FROM LichHen WHERE lichHenId = ?")) {
        ps.setInt(1, Integer.parseInt(lichHenIdParam));
        rs = ps.executeQuery();
        if (rs.next()) {
            showLichHenId = rs.getInt("lichHenId");
            request.setAttribute("lh_idBenhNhan", rs.getObject("idBenhNhan"));
            request.setAttribute("lh_idBacSi", rs.getObject("idBacSi"));
            request.setAttribute("lh_idPhong", rs.getObject("idPhong"));
            request.setAttribute("lh_idCa", rs.getObject("idCa"));
            request.setAttribute("lh_ngayHen", rs.getObject("NGAYHEN"));
            request.setAttribute("lh_timeStart", rs.getObject("timeStart"));
            request.setAttribute("lh_timeEnd", rs.getObject("timeEnd"));
            request.setAttribute("lh_chiphi", rs.getObject("CHIPHI"));
            request.setAttribute("lh_lydokham", rs.getObject("LYDOKHAM"));
            request.setAttribute("lh_trangthai", rs.getObject("TRANGTHAI"));
        } else {
            err = "Không tìm thấy LichHenId = " + lichHenIdParam;
        }
    } catch (Exception ex) {
        ex.printStackTrace();
        err = "Lỗi khi truy vấn lịch hẹn: " + ex.getMessage();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception ignore){}
    }
}
%>

<!-- Form Kiểm tra (GET) -->
<form method="get" action="<%=request.getContextPath()%>/bacsi/taoHoSo.jsp">
    <label>Nhập Lịch Hẹn ID:</label>
    <input type="number" name="lichHenId" value="<%= (lichHenIdParam != null ? lichHenIdParam : "") %>" required />
    <button type="submit">Kiểm tra</button>
</form>

<% if (err != null) { %>
    <p class="err"><%= err %></p>
<% } %>

<% if (showLichHenId != null) { %>
    <div class="info">
        <h4>Thông tin Lịch Hẹn</h4>
        <p><b>LichHenId:</b> <%= showLichHenId %></p>
        <p><b>IdBenhNhan:</b> <%= request.getAttribute("lh_idBenhNhan") %></p>
        <p><b>IdBacSi:</b> <%= request.getAttribute("lh_idBacSi") %></p>
        <p><b>IdPhong:</b> <%= request.getAttribute("lh_idPhong") %></p>
        <p><b>IdCa:</b> <%= request.getAttribute("lh_idCa") %></p>
        <p><b>Ngày:</b> <%= request.getAttribute("lh_ngayHen") %></p>
        <p><b>TimeStart - TimeEnd:</b> <%= request.getAttribute("lh_timeStart") %> - <%= request.getAttribute("lh_timeEnd") %></p>
        <p><b>Chi phí:</b> <%= request.getAttribute("lh_chiphi") %></p>
        <p><b>Lý do khám:</b> <%= request.getAttribute("lh_lydokham") %></p>
        <p><b>Trạng thái:</b> <%= request.getAttribute("lh_trangthai") %></p>

        <hr/>
        <form method="post" action="<%=request.getContextPath()%>/bacsi/taoHoSo.jsp">
            <input type="hidden" name="action" value="save"/>
            <input type="hidden" name="lichHenId" value="<%= showLichHenId %>"/>
            <label>Kết quả khám (KetQua):</label>
            <textarea name="ketQua" rows="4" required></textarea><br/>
            <button type="submit">Đồng ý - Tạo hồ sơ & Thêm đơn thuốc</button>
            <a href="<%=request.getContextPath()%>/bacsi/index.jsp">Hủy</a>
        </form>
    </div>
<% } %>

</body>
</html>
