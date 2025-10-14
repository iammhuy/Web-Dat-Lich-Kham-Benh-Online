<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    // Kiểm tra đăng nhập
    Object u = session.getAttribute("user");
    if (u == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Kiểm tra quyền bác sĩ
    boolean isBacSi = u.getClass().getName().endsWith("BacSi") 
                      || u instanceof app.business.nguoidung.BacSi;
    if (!isBacSi) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Bảng điều khiển - Bác sĩ</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style> body { font-family: 'Inter', sans-serif; } </style>
</head>
<body class="bg-gray-100 min-h-screen">

<jsp:include page="/layout/header.jsp" />

<div class="container mx-auto px-4 py-8 md:py-12">

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <!-- THÔNG TIN CÁ NHÂN -->
        <div class="lg:col-span-1 bg-white p-6 rounded-lg shadow-md">
            <h3 class="text-xl font-semibold text-gray-700 mb-4 border-b pb-3">Thông tin bác sĩ</h3>

            <div class="space-y-2 text-sm text-gray-700">
                <p><b>Mã bác sĩ:</b> ${sessionScope.user.userId}</p>
                <p><b>Họ và tên:</b> ${sessionScope.user.firstName} ${sessionScope.user.lastName}</p>
                <p><b>Giới tính:</b> ${sessionScope.user.gender}</p>
                <p><b>Ngày sinh:</b> ${sessionScope.user.birthday}</p>
                <p><b>Chuyên ngành:</b> ${sessionScope.user.chuyenNganh}</p>
                <p><b>Bằng cấp:</b> ${sessionScope.user.bangCap}</p>
                <p><b>Kinh nghiệm:</b> 
                    <c:choose>
                        <c:when test="${not empty sessionScope.user.kinhNghiem}">
                            ${sessionScope.user.kinhNghiem} năm
                        </c:when>
                        <c:otherwise>—</c:otherwise>
                    </c:choose>
                </p>
                <p><b>Chi phí khám:</b> 
                    <c:choose>
                        <c:when test="${sessionScope.user.chiPhiKham > 0}">
                            ${sessionScope.user.chiPhiKham} VNĐ
                        </c:when>
                        <c:otherwise>—</c:otherwise>
                    </c:choose>
                </p>
                <p><b>Khoa công tác:</b>
                    <c:choose>
                        <c:when test="${not empty sessionScope.user.khoa}">
                            ${sessionScope.user.khoa.tenKhoa}
                        </c:when>
                        <c:otherwise>—</c:otherwise>
                    </c:choose>
                </p>
                <p><b>Email:</b> ${sessionScope.user.email}</p>
                <p><b>Số điện thoại:</b> ${sessionScope.user.phoneNumber}</p>
                <p><b>Địa chỉ:</b> ${sessionScope.user.address}</p>
            </div>

            <div class="mt-6 flex flex-col sm:flex-row gap-3">
                
                <a href="${pageContext.request.contextPath}/user?action=logout"
                   class="w-full text-center px-4 py-2 bg-red-100 text-red-700 font-semibold rounded-lg hover:bg-red-200 transition">
                    Đăng xuất
                </a>
            </div>

            <c:if test="${not empty successMsg}">
                <div class="mt-4 bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded">
                    ${successMsg}
                </div>
            </c:if>
        </div>

        <!-- NỘI DUNG CHÍNH -->
        <div class="lg:col-span-2 space-y-6">

            <!-- Lịch khám -->
            <div class="bg-white p-6 rounded-lg shadow-md">
                <h3 class="text-xl font-semibold text-gray-700 mb-4">Lịch khám theo ngày</h3>

                <form method="get" action="${pageContext.request.contextPath}/bacsi" class="flex gap-3 items-center">
                    <input type="hidden" name="action" value="viewSchedule"/>
                    <label class="text-sm">Chọn ngày:</label>
                    <input type="date" name="date" required
                           value="${param.date != null ? param.date : '' }"
                           class="border rounded px-3 py-2"/>
                    <button type="submit" class="ml-2 bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
                        Xem
                    </button>
                </form>

                <div class="mt-4">
                    <c:choose>
                        <c:when test="${not empty scheduleList}">
                            <table class="min-w-full bg-white">
                                <thead>
                                    <tr class="bg-gray-100 text-left text-gray-700">
                                        <th class="px-3 py-2">Giờ</th>
                                        <th class="px-3 py-2">Bệnh nhân</th>
                                        <th class="px-3 py-2">Số điện thoại</th>
                                        <th class="px-3 py-2">Phòng</th>
                                        <th class="px-3 py-2">Trạng thái</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="s" items="${scheduleList}">
                                        <tr class="border-t hover:bg-gray-50">
                                            <td class="px-3 py-2">${s.time != null ? s.time : s.gio}</td>
                                            <td class="px-3 py-2">${s.benhNhanName}</td>
                                            <td class="px-3 py-2">${s.benhNhanPhone}</td>
                                            <td class="px-3 py-2">${s.phong != null ? s.phong.tenPhong : '-'}</td>
                                            <td class="px-3 py-2">${s.status}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:when>
                        <c:otherwise>
                            <p class="text-sm text-gray-500 mt-3">Chưa có lịch cho ngày được chọn.</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Yêu cầu đặt lịch -->
            <div class="bg-white p-6 rounded-lg shadow-md">
                <h3 class="text-xl font-semibold text-gray-700 mb-4">Yêu cầu đặt lịch</h3>

                <div class="flex gap-3 mb-3">
                    <a href="${pageContext.request.contextPath}/bacsi?action=requests"
                       class="px-4 py-2 bg-indigo-600 text-white rounded hover:bg-indigo-700">Xem tất cả yêu cầu</a>
                    <a href="${pageContext.request.contextPath}/bacsi?action=requests&status=pending"
                       class="px-4 py-2 bg-yellow-50 text-yellow-800 rounded hover:bg-yellow-100">Chờ xử lý</a>
                </div>

                <c:choose>
                    <c:when test="${not empty requestList}">
                        <table class="min-w-full bg-white">
                            <thead>
                                <tr class="bg-gray-100 text-left text-gray-700">
                                    <th class="px-3 py-2">Bệnh nhân</th>
                                    <th class="px-3 py-2">Ngày - Giờ</th>
                                    <th class="px-3 py-2">Ghi chú</th>
                                    <th class="px-3 py-2">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="r" items="${requestList}">
                                    <tr class="border-t hover:bg-gray-50">
                                        <td class="px-3 py-2">${r.benhNhanName} <br/><small>${r.benhNhanPhone}</small></td>
                                        <td class="px-3 py-2">${r.date} ${r.time}</td>
                                        <td class="px-3 py-2">${r.note}</td>
                                        <td class="px-3 py-2">
                                            <form method="post" action="${pageContext.request.contextPath}/bacsi" style="display:inline">
                                                <input type="hidden" name="action" value="approveRequest"/>
                                                <input type="hidden" name="requestId" value="${r.id}"/>
                                                <input type="text" name="phongId" placeholder="ID phòng" class="border rounded px-2 py-1 mr-2" />
                                                <button type="submit" class="px-3 py-1 bg-green-600 text-white rounded">Chấp nhận</button>
                                            </form>
                                            <form method="post" action="${pageContext.request.contextPath}/bacsi" style="display:inline">
                                                <input type="hidden" name="action" value="rejectRequest"/>
                                                <input type="hidden" name="requestId" value="${r.id}"/>
                                                <button type="submit" class="px-3 py-1 bg-red-500 text-white rounded ml-2">Từ chối</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <p class="text-sm text-gray-500">Không có yêu cầu mới.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/layout/footer.jsp" />
</body>
</html>
