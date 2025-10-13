<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Bác sĩ - BUH Clinic</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; }
    </style>
</head>
<body class="bg-gray-100">

    <jsp:include page="/layout/header.jsp" />

    <main class="container mx-auto px-4 py-8">
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-3xl font-bold text-gray-800">Danh sách Bác sĩ</h1>
            <a href="${pageContext.request.contextPath}/admin/bacsi-form.jsp" class="bg-blue-600 hover:bg-blue-700 text-white font-semibold py-2 px-4 rounded-lg shadow-md transition duration-300">
                + Thêm Bác sĩ mới
            </a>
        </div>

        <div class="bg-white rounded-lg shadow-md overflow-hidden">
            <table class="min-w-full leading-normal">
                <thead>
                    <tr class="bg-gray-200 text-left text-gray-600 uppercase text-sm">
                        <th class="px-5 py-3">Họ Tên</th>
                        <th class="px-5 py-3">Chuyên khoa</th>
                        <th class="px-5 py-3">Email</th>
                        <th class="px-5 py-3">Số điện thoại</th>
                        <th class="px-5 py-3">Hành động</th>
                    </tr>
                </thead>
                <tbody class="text-gray-700">
                    <%-- Dùng JSTL để lặp qua danh sách bác sĩ từ Servlet --%>
                    <c:forEach var="bacSi" items="${listBacSi}">
                        <tr class="border-b border-gray-200 hover:bg-gray-50">
                            <td class="px-5 py-4">
                                <p class="font-semibold">${bacSi.firstName} ${bacSi.lastName}</p>
                            </td>
                            <td class="px-5 py-4">
                                <p>${bacSi.chuyenNganh}</p>
                            </td>
                            <td class="px-5 py-4">
                                <p>${bacSi.email}</p>
                            </td>
                            <td class="px-5 py-4">
                                <p>${bacSi.phoneNumber}</p>
                            </td>
                            <td class="px-5 py-4 text-sm font-semibold">
                                <a href="bacsi?action=edit&id=${bacSi.id}" class="text-blue-600 hover:text-blue-800 mr-4">Sửa</a>
                                <a href="bacsi?action=delete&id=${bacSi.id}" class="text-red-600 hover:text-red-800" onclick="return confirm('Bạn có chắc muốn xóa?')">Xóa</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty listBacSi}">
                        <tr>
                            <td colspan="5" class="text-center py-10 text-gray-500">Không có dữ liệu bác sĩ.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </main>

    <jsp:include page="/layout/footer.jsp" />

</body>
</html>