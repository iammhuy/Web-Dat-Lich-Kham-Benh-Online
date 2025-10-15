<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page session="true" %>
<%
    String user = (String) session.getAttribute("username");
    String currentPage = request.getRequestURI(); // 🟢 LẤY ĐƯỜNG DẪN TRANG HIỆN TẠI
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Bệnh viện Đa Khoa Online</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <style>
        /* 🟢 Giữ hộp chat luôn cố định ở góc dưới bên phải */
        #chatBox {
            position: fixed;
            bottom: 25px;
            right: 25px;
            z-index: 9999;
        }

        #chatButton {
            background-color: #0d6efd;
            color: white;
            border: none;
            border-radius: 50%;
            width: 60px;
            height: 60px;
            font-size: 24px;
            box-shadow: 0px 4px 10px rgba(0,0,0,0.3);
            transition: all 0.3s;
        }

        #chatButton:hover {
            background-color: #0b5ed7;
            transform: scale(1.05);
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-primary fixed-top shadow">
    <div class="container">
        <a class="navbar-brand fw-bold" href="<%=request.getContextPath()%>/index.jsp">
            <img src="<%=request.getContextPath()%>/assets/images/logo.png" alt="logo" width="40" class="me-2">
            BV Đa Khoa Online
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#menu">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="menu">
            <ul class="navbar-nav ms-auto">
                <% if (user == null) { %>
                    <li class="nav-item">
                        <a class="nav-link text-white" href="<%=request.getContextPath()%>/login.jsp">
                            <i class="fa-solid fa-calendar-check me-1"></i> Đặt lịch
                        </a>
                    </li>
                <% } else { %>
                    <li class="nav-item">
                        <a class="nav-link text-white" href="<%=request.getContextPath()%>/benhnhan/datlich.jsp">
                            <i class="fa-solid fa-calendar-check me-1"></i> Đặt lịch
                        </a>
                    </li>
                <% } %>

                <li class="nav-item">
                    <a class="nav-link text-white" href="<%=request.getContextPath()%>/benhnhan/lichsu.jsp">
                        <i class="fa-solid fa-clock-rotate-left me-1"></i> Lịch sử
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-white" href="<%=request.getContextPath()%>/benhnhan/dashboard.jsp">
                        <i class="fa-solid fa-user-circle me-1"></i> Tài khoản
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div style="margin-top: 85px"></div>

<%-- 🟢 HIỂN THỊ BOX CHAT CHỈ KHI KHÔNG PHẢI TRANG chat.jsp --%>
<%
    if (!currentPage.endsWith("chat.jsp")) {
%>
    <div id="chatBox">
        <button id="chatButton" onclick="window.location.href='<%=request.getContextPath()%>/chat.jsp'">
            <i class="fa-solid fa-comments"></i>
        </button>
    </div>
<%
    }
%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
