<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    // Bảo vệ trang: Nếu chưa đăng nhập, chuyển về trang login
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bảng điều khiển - Bệnh nhân</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
        }
    </style>
</head>
<body class="bg-gray-100">

<jsp:include page="/layout/header.jsp" />

<div class="container mx-auto px-4 py-8 md:py-12">
    <h1 class="text-3xl font-bold text-gray-800 mb-8">
        Chào mừng, ${sessionScope.user.firstName} ${sessionScope.user.lastName}!
    </h1>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <!-- Thông tin cá nhân -->
        <div class="lg:col-span-1 bg-white p-6 rounded-lg shadow-md">
            <h3 class="text-xl font-semibold text-gray-700 mb-4 border-b pb-3">Thông tin cá nhân</h3>
            <div class="space-y-3 text-sm text-gray-600">
                <p><b>Mã bệnh nhân:</b> ${sessionScope.user.userId}</p>
                <p><b>Họ và tên:</b> ${sessionScope.user.firstName} ${sessionScope.user.lastName}</p>
                <p><b>Email:</b> ${sessionScope.user.email}</p>
                <p><b>Giới tính:</b> ${sessionScope.user.gender}</p>
                <p><b>Ngày sinh:</b> ${sessionScope.user.birthday}</p>
                <p><b>Số điện thoại:</b> ${sessionScope.user.phoneNumber}</p>
                <p><b>Địa chỉ:</b> ${sessionScope.user.address}</p>
            </div>
                
            <div class="mt-6 flex flex-col sm:flex-row gap-3">
                <a href="${pageContext.request.contextPath}/benhnhan/editprofile.jsp"
                   class="w-full text-center px-4 py-2 bg-blue-600 text-white font-semibold rounded-lg hover:bg-blue-700 transition">
                    ✏️ Cập nhật
                </a>
                <a href="${pageContext.request.contextPath}/user?action=logout"
                   class="w-full text-center px-4 py-2 bg-red-100 text-red-700 font-semibold rounded-lg hover:bg-red-200 transition">
                    Đăng xuất
                </a>
            </div>

            <c:if test="${not empty successMsg}">
                <div class="mt-4 bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative" role="alert">
                    ${successMsg}
                </div>
            </c:if>
        </div>

        <!-- Chức năng chính -->
        <div class="lg:col-span-2 space-y-6">
            <div class="bg-white p-6 rounded-lg shadow-md">
                <h3 class="text-xl font-semibold text-gray-700 mb-4">Chức năng chính</h3>
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <a href="${pageContext.request.contextPath}/LichHenController?action=prepareAdd"
                       class="flex flex-col items-center justify-center p-6 bg-green-50 rounded-lg text-green-700 hover:bg-green-100 hover:shadow-lg transition">
                        <svg class="h-10 w-10 mb-2" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round"
                                  d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 012.25-2.25h13.5A2.25 2.25 0 0121 7.5v11.25m-18 0A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75m-18 0h18M-4.5 12h22.5" />
                        </svg>
                        <span class="font-semibold">Đặt lịch khám mới</span>
                    </a>

                    <a href="${pageContext.request.contextPath}/benhnhan/xemLichSuKham.jsp"
                       class="flex flex-col items-center justify-center p-6 bg-indigo-50 rounded-lg text-indigo-700 hover:bg-indigo-100 hover:shadow-lg transition">
                        <svg class="h-10 w-10 mb-2" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round"
                                  d="M12 6.042A8.967 8.967 0 006 3.75c-1.052 0-2.062.18-3 .512v14.25A8.987 8.987 0 016 18c2.305 0 4.408.867 6 2.292m0-14.25a8.966 8.966 0 016-2.292c1.052 0 2.062.18 3 .512v14.25A8.987 8.987 0 0018 18a8.967 8.967 0 00-6 2.292m0-14.25v14.25" />
                        </svg>
                        <span class="font-semibold">Xem lịch sử khám</span>
                    <a href="${pageContext.request.contextPath}/LichHenController?action=list"
                        class="flex flex-col items-center justify-center p-6 bg-blue-50 rounded-lg text-blue-700 hover:bg-blue-100 hover:shadow-lg transition">
                         <svg class="h-10 w-10 mb-2" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                             <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 12h16.5m-16.5 3.75h16.5M3.75 19.5h16.5M5.625 4.5h12.75a1.875 1.875 0 010 3.75H5.625a1.875 1.875 0 010-3.75z" />
                         </svg>
                         <span class="font-semibold text-center">Lịch hẹn của tôi</span>
                     </a>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/layout/footer.jsp" />

</body>
</html>
