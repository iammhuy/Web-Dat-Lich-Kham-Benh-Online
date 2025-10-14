<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="app.business.nguoidung.BenhNhan, app.business.nguoidung.BacSi, app.business.nguoidung.QuanTriVien" %>
<%
    // Kiểm tra xem có user đã đăng nhập trong session chưa
    Object user = session.getAttribute("user");

    if (user != null) {
        // Nếu là Quản trị viên
        if (user instanceof app.business.nguoidung.QuanTriVien) {
            response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
            return;
        }

        // Nếu là Bác sĩ
        if (user instanceof app.business.nguoidung.BacSi) {
            response.sendRedirect(request.getContextPath() + "/bacsi/index.jsp");
            return;
        }

        // Nếu là Bệnh nhân
        if (user instanceof app.business.nguoidung.BenhNhan) {
            response.sendRedirect(request.getContextPath() + "/benhnhan/dashboard.jsp");
            return;
        }
    }
%>

<!DOCTYPE html>
<html lang="vi" class="h-full bg-gray-50">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập </title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; }
    </style>
</head>
<body class="h-full">

    <jsp:include page="/layout/header.jsp" />

    <main class="flex min-h-full flex-col justify-center px-6 py-12 lg:px-8">
        <div class="sm:mx-auto sm:w-full sm:max-w-md">
            <h2 class="mt-10 text-center text-3xl font-bold leading-9 tracking-tight text-gray-900">
                Đăng nhập vào tài khoản
            </h2>
        </div>

        <div class="mt-10 sm:mx-auto sm:w-full sm:max-w-md">
            <div class="bg-white py-8 px-4 shadow sm:rounded-lg sm:px-10">
                <form class="space-y-6" action="${pageContext.request.contextPath}/user" method="POST">
                    <input type="hidden" name="action" value="login"/>
                    
                    <div>
                        <label for="email" class="block text-sm font-medium leading-6 text-gray-900">Địa chỉ email</label>
                        <div class="mt-2">
                            <input id="email" name="email" type="email" autocomplete="email" required 
                                   class="block w-full rounded-md border-0 py-2.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-blue-600 sm:text-sm sm:leading-6">
                        </div>
                    </div>

                    <div>
                        <div class="flex items-center justify-between">
                            <label for="password" class="block text-sm font-medium leading-6 text-gray-900">Mật khẩu</label>
                            <div class="text-sm">
                                <a href="#" class="font-semibold text-blue-600 hover:text-blue-500">Quên mật khẩu?</a>
                            </div>
                        </div>
                        <div class="mt-2">
                            <input id="password" name="password" type="password" autocomplete="current-password" required 
                                   class="block w-full rounded-md border-0 py-2.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-blue-600 sm:text-sm sm:leading-6">
                        </div>
                    </div>
                    
                    <c:if test="${not empty loginError}">
                      <div class="rounded-md bg-red-50 p-4">
                          <p class="text-sm font-medium text-red-800">${loginError}</p>
                      </div>
                    </c:if>
                    
                    <div>
                        <button type="submit" class="flex w-full justify-center rounded-md bg-blue-600 px-3 py-2.5 text-sm font-semibold leading-6 text-white shadow-sm hover:bg-blue-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-blue-600">
                            Đăng nhập
                        </button>
                    </div>
                </form>

                <p class="mt-10 text-center text-sm text-gray-500">
                    Chưa có tài khoản?
                    <a href="${pageContext.request.contextPath}/register.jsp" class="font-semibold leading-6 text-blue-600 hover:text-blue-500">Đăng ký ngay</a>
                </p>
            </div>
        </div>
    </main>

    <jsp:include page="/layout/footer.jsp" />

</body>
</html>