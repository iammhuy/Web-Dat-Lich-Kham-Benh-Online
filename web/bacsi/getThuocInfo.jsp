<%@ page import="java.sql.*, app.database.DBUtil" %>
<%@ page contentType="application/json; charset=UTF-8" %>
<%
    String idStr = request.getParameter("thuocId");
    String tenThuoc = "";
    String congDung = "";
    String error = "";

    if (idStr != null && !idStr.isEmpty()) {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT TenThuoc, CongDung FROM Thuoc WHERE ThuocId = ?")) {
            ps.setInt(1, Integer.parseInt(idStr));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    tenThuoc = rs.getString("TenThuoc");
                    congDung = rs.getString("CongDung");
                } else {
                    error = "Không tìm thấy thuốc.";
                }
            }
        } catch (Exception e) {
            error = e.getMessage();
        }
    } else {
        error = "Thiếu tham số thuocId";
    }

    // Xuất JSON thủ công
    out.print("{");
    out.print("\"tenThuoc\":\"" + tenThuoc.replace("\"","\\\"") + "\",");
    out.print("\"congDung\":\"" + congDung.replace("\"","\\\"") + "\",");
    out.print("\"error\":\"" + error.replace("\"","\\\"") + "\"");
    out.print("}");
%>
