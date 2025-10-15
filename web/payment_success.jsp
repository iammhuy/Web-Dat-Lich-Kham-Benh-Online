<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="app.business.giaodich.ThanhToan"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thanh toán thành công</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f7fc;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            color: #333;
        }
        .container {
            background: #ffffff;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 5px 25px rgba(0,0,0,0.1);
            text-align: center;
            width: 550px;
            border-top: 5px solid #4CAF50;
        }
        h1 {
            color: #2e7d32;
            font-size: 26px;
            margin-bottom: 15px;
        }
        .icon {
            font-size: 52px;
            color: #4CAF50;
        }
        .details {
            text-align: left;
            margin-top: 30px;
            border-top: 1px solid #eee;
            padding-top: 20px;
        }
        .details p {
            font-size: 16px;
            line-height: 1.8;
            margin: 10px 0;
            display: flex;
            justify-content: space-between;
        }
        .details strong {
            color: #555;
            margin-right: 15px;
        }
        .home-button {
            display: inline-block;
            margin-top: 30px;
            text-decoration: none;
            color: white;
            background-color: #4CAF50;
            padding: 12px 25px;
            border-radius: 5px;
            font-size: 16px;
            font-weight: bold;
            transition: background-color 0.3s ease;
        }
        .home-button:hover {
            background-color: #388e3c;
        }
    </style>
</head>
<body>
    <%-- Lấy đối tượng ThanhToan đã được gửi từ Servlet --%>
    <%
        ThanhToan thanhToan = (ThanhToan) request.getAttribute("thanhToanInfo");
        // Định dạng tiền tệ VNĐ
        NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    %>

    <div class="container">
        <div class="icon">✔</div>
        <h1>Thanh toán thành công!</h1>
        <p>Cảm ơn bạn đã hoàn tất thanh toán. Dưới đây là thông tin chi tiết giao dịch của bạn.</p>

        <%-- Kiểm tra nếu có thông tin thanh toán thì mới hiển thị --%>
        <% if (thanhToan != null) { %>
            <div class="details">
                <p><strong>Mã giao dịch hệ thống:</strong> <span><%= thanhToan.getThanhToanId() %></span></p>
                <p><strong>Mã lịch hẹn:</strong> <span><%= thanhToan.getLichHenId() %></span></p>
                <p><strong>Số tiền:</strong> <span><%= currencyFormatter.format(thanhToan.getSoTien()) %></span></p>
                <p><strong>Phương thức:</strong> <span><%= thanhToan.getPhuongThuc() %></span></p>
                <p><strong>Mã giao dịch VNPAY:</strong> <span><%= thanhToan.getMaGiaoDichVnpay() %></span></p>
                <p><strong>Trạng thái:</strong> <span style="color: #2e7d32; font-weight: bold;"><%= thanhToan.getTrangThai() %></span></p>
            </div>
        <% } %>

        <form action="<%= request.getContextPath() %>/LichHenController" method="get" style="display:inline">
         <input type="hidden" name="action" value="assignRoom" />
         <input type="hidden" name="lichHenId" value="<%= request.getAttribute("lichHenId") != null ? request.getAttribute("lichHenId") : "" %>" />
            <button type="submit"
            style="background-color: #22c55e; color: white; padding: 10px 20px; border: none; border-radius: 6px; 
                   cursor: pointer; font-weight: 500; transition: background-color 0.2s ease;"
            onmouseover="this.style.backgroundColor='#16a34a'"
            onmouseout="this.style.backgroundColor='#22c55e'">
                    Về trang chủ
            </button>
        </form>
    </div>
</body>
</html>