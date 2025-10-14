<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page session="true" %>
<%
    String user = (String) session.getAttribute("username");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Bệnh viện Đa Khoa Online</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
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
