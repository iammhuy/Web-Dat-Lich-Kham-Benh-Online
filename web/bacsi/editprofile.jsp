<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cập nhật thông tin cá nhân - BUH Clinic</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; }
    </style>
</head>
<body class="bg-gray-100">

    <jsp:include page="/layout/header.jsp" />

    <main class="container mx-auto px-4 py-8">
        <div class="max-w-2xl mx-auto bg-white p-8 rounded-lg shadow-md">
            <h1 class="text-2xl font-bold text-gray-800 mb-6">Cập nhật thông tin cá nhân</h1>
            
            <form action="${pageContext.request.contextPath}/user" method="POST" class="space-y-6">
                <input type="hidden" name="action" value="editprofile"/>

                <!-- Email -->
                <div>
                    <label class="block text-sm font-medium text-gray-500">Email (không thể thay đổi)</label>
                    <input type="email" value="${sessionScope.user.email}" readonly class="mt-1 block w-full rounded-md border-gray-300 bg-gray-100 shadow-sm">
                </div>

                <!-- Họ tên -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                        <label for="firstName" class="block text-sm font-medium text-gray-700">Họ</label>
                        <input type="text" name="firstName" id="firstName" value="${sessionScope.user.firstName}" required class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">
                    </div>
                    <div>
                        <label for="lastName" class="block text-sm font-medium text-gray-700">Tên</label>
                        <input type="text" name="lastName" id="lastName" value="${sessionScope.user.lastName}" required class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">
                    </div>
                </div>
                
                <!-- Giới tính và ngày sinh -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                        <label for="gender" class="block text-sm font-medium text-gray-700">Giới tính</label>
                        <select name="gender" id="gender" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">
                            <option value="Nam" <c:if test="${sessionScope.user.gender eq 'Nam'}">selected</c:if>>Nam</option>
                            <option value="Nữ" <c:if test="${sessionScope.user.gender eq 'Nữ'}">selected</c:if>>Nữ</option>
                        </select>
                    </div>
                    <div>
                        <label for="birthday" class="block text-sm font-medium text-gray-700">Ngày sinh</label>
                        <input type="date" name="birthday" id="birthday" value="${sessionScope.user.birthday}" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">
                    </div>
                </div>

                <!-- Số điện thoại -->
                <div>
                    <label for="phoneNumber" class="block text-sm font-medium text-gray-700">Số điện thoại</label>
                    <input type="tel" name="phoneNumber" id="phoneNumber" value="${sessionScope.user.phoneNumber}" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">
                </div>
                
                <!-- Địa chỉ -->
                <div>
                    <label for="address" class="block text-sm font-medium text-gray-700">Địa chỉ</label>
                    <input type="text" name="address" id="address" value="${sessionScope.user.address}" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">
                </div>

                <!-- Phần riêng cho bác sĩ -->
                <c:if test="${sessionScope.user.class.simpleName eq 'BacSi'}">
                    <hr class="my-6 border-gray-300">
                    <h2 class="text-xl font-semibold text-gray-800 mb-4">Thông tin chuyên môn</h2>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label for="chuyenNganh" class="block text-sm font-medium text-gray-700">Chuyên ngành</label>
                            <input type="text" name="chuyenNganh" id="chuyenNganh" value="${sessionScope.user.chuyenNganh}" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">
                        </div>
                        <div>
                            <label for="bangCap" class="block text-sm font-medium text-gray-700">Bằng cấp</label>
                            <input type="text" name="bangCap" id="bangCap" value="${sessionScope.user.bangCap}" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label for="kinhNghiem" class="block text-sm font-medium text-gray-700">Kinh nghiệm (năm)</label>
                            <input type="number" name="kinhNghiem" id="kinhNghiem" value="${sessionScope.user.kinhNghiem}" min="0" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">
                        </div>
                        <div>
                            <label for="chiPhiKham" class="block text-sm font-medium text-gray-700">Chi phí khám (VNĐ)</label>
                            <input type="number" name="chiPhiKham" id="chiPhiKham" value="${sessionScope.user.chiPhiKham}" min="0" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">
                        </div>
                    </div>

                    <div>
                        <label for="khoa" class="block text-sm font-medium text-gray-700">Khoa phụ trách</label>
                        <select name="khoaId" id="khoa" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">
                            <c:forEach var="k" items="${listKhoa}">
                                <option value="${k.id}" <c:if test="${sessionScope.user.khoa.id eq k.id}">selected</c:if>>${k.tenKhoa}</option>
                            </c:forEach>
                        </select>
                    </div>
                </c:if>

                <!-- Nút điều hướng -->
                <div class="flex justify-between items-center pt-6">
                    <a href="${pageContext.request.contextPath}/bacsi/index.jsp" class="text-sm font-semibold text-gray-600 hover:text-gray-800">
                        &larr; Quay lại
                    </a>
                    <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white font-semibold py-2 px-5 rounded-lg shadow-md transition duration-300">
                        Lưu thay đổi
                    </button>
                </div>
            </form>
        </div>
    </main>

    <jsp:include page="/layout/footer.jsp" />

</body>
</html>
