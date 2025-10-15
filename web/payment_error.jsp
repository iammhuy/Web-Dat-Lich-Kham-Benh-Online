<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thanh toán thất bại</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #fff0f0;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
            color: #c62828;
        }
        .container {
            background: #ffffff;
            padding: 30px 40px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.2);
            text-align: center;
        }
        h1 {
            color: #c62828;
        }
        a {
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
            color: white;
            background-color: #d32f2f;
            padding: 10px 20px;
            border-radius: 5px;
        }
        a:hover {
            background-color: #b71c1c;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>❌ Thanh toán thất bại</h1>
        <p><strong><%= request.getAttribute("message") != null ? request.getAttribute("message") : "Đã có lỗi xảy ra trong quá trình thanh toán." %></strong></p>
        <p>Mã lỗi: <%= request.getParameter("vnp_ResponseCode") %></p>
        <a href="index.jsp">Thử lại</a>
    </div>
</body>
</html>
