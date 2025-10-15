<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thanh toán thành công</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0fff0;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
            color: #2e7d32;
        }
        .container {
            background: #ffffff;
            padding: 30px 40px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.2);
            text-align: center;
        }
        h1 {
            color: #2e7d32;
        }
        a {
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
            color: white;
            background-color: #4CAF50;
            padding: 10px 20px;
            border-radius: 5px;
        }
        a:hover {
            background-color: #388e3c;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🎉 Thanh toán thành công!</h1>
        <p><strong><%= request.getAttribute("message") != null ? request.getAttribute("message") : "Cảm ơn bạn đã thanh toán." %></strong></p>
        <p>Mã giao dịch: <%= request.getParameter("vnp_TransactionNo") %></p>
        <a href="index.jsp">Về trang chủ</a>
    </div>
</body>
</html>
