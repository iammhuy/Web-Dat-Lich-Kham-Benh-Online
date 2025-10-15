<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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
    <title>Lịch Hẹn Của Tôi</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; }
    </style>
</head>
<body class="bg-gray-100">

<jsp:include page="/layout/header.jsp" />

<div class="container mx-auto px-4 py-8 md:py-12">
    <h1 class="text-3xl font-bold text-gray-800 mb-8">Lịch Hẹn Của Tôi</h1>

    <div class="bg-white rounded-lg shadow-md">
        <%-- PHẦN LỊCH HẸN CHỜ XÁC NHẬN --%>
        <div class="p-6">
            <h3 class="text-xl font-semibold text-gray-700 mb-4 border-b pb-3">⏳ Lịch hẹn chờ xác nhận</h3>
            <c:choose>
                <c:when test="${not empty lichChuaXN}">
                    <div class="overflow-x-auto">
                        <table class="w-full text-sm text-left text-gray-500">
                            <thead class="text-xs text-gray-700 uppercase bg-gray-50">
                                <tr>
                                    <th scope="col" class="px-6 py-3">Bác sĩ & Chuyên khoa</th>
                                    <th scope="col" class="px-6 py-3">Ngày & Ca khám</th>
                                    <th scope="col" class="px-6 py-3">Lý do</th>
                                    <th scope="col" class="px-6 py-3">Chi phí</th> <th scope="col" class="px-6 py-3">Trạng thái</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="lh" items="${lichChuaXN}">
                                    <tr class="bg-white border-b hover:bg-gray-50">
                                        <td class="px-6 py-4">
                                            <div class="font-medium text-gray-900">${lh.bacSi.lastName} ${lh.bacSi.firstName}</div>
                                            <div class="text-gray-500">${lh.bacSi.khoa.tenKhoa}</div>
                                        </td>
                                        <td class="px-6 py-4">
                                            <div><fmt:formatDate value='${lh.ngayHen}' pattern='dd/MM/yyyy'/></div>
                                            <div>
                                                <c:if test="${lh.caKham != null}">
                                                    <fmt:formatDate value='${lh.caKham.gioBatDau}' pattern='HH:mm'/> - <fmt:formatDate value='${lh.caKham.gioKetThuc}' pattern='HH:mm'/>
                                                </c:if>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4">${lh.lyDoKham}</td>
                                        <td class="px-6 py-4 font-medium text-gray-800">
                                            <fmt:formatNumber value="${lh.chiPhi}" type="currency" currencySymbol="₫" groupingUsed="true" />
                                        </td>
                                        <td class="px-6 py-4">
                                            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-yellow-100 text-yellow-800">
                                                ${lh.trangThai}
                                            </span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <p class="text-sm text-gray-500 italic">Không có lịch hẹn nào đang chờ xác nhận.</p>
                </c:otherwise>
            </c:choose>
        </div>

        <%-- PHẦN LỊCH HẸN ĐÃ XÁC NHẬN --%>
        <div class="p-6 border-t border-gray-200">
            <h3 class="text-xl font-semibold text-gray-700 mb-4 border-b pb-3">✅ Lịch hẹn đã xác nhận</h3>
            <c:choose>
                <c:when test="${not empty lichDaXN}">
                    <div class="overflow-x-auto">
                        <table class="w-full text-sm text-left text-gray-500">
                            <thead class="text-xs text-gray-700 uppercase bg-gray-50">
                                <tr>
                                    <th scope="col" class="px-6 py-3">Bác sĩ & Chuyên khoa</th>
                                    <th scope="col" class="px-6 py-3">Ngày & Ca khám</th>
                                    <th scope="col" class="px-6 py-3">Lý do</th>
                                    <th scope="col" class="px-6 py-3">Chi phí</th> <th scope="col" class="px-6 py-3">Trạng thái</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="lh" items="${lichDaXN}">
                                    <tr class="bg-white border-b hover:bg-gray-50">
                                        <td class="px-6 py-4">
                                            <div class="font-medium text-gray-900">${lh.bacSi.lastName} ${lh.bacSi.firstName}</div>
                                            <div class="text-gray-500">${lh.bacSi.khoa.tenKhoa}</div>
                                        </td>
                                        <td class="px-6 py-4">
                                            <div><fmt:formatDate value='${lh.ngayHen}' pattern='dd/MM/yyyy'/></div>
                                            <div>
                                                <c:if test="${lh.caKham != null}">
                                                    <fmt:formatDate value='${lh.caKham.gioBatDau}' pattern='HH:mm'/> - <fmt:formatDate value='${lh.caKham.gioKetThuc}' pattern='HH:mm'/>
                                                </c:if>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4">${lh.lyDoKham}</td>
                                        <td class="px-6 py-4 font-medium text-gray-800">
                                            <fmt:formatNumber value="${lh.chiPhi}" type="currency" currencySymbol="₫" groupingUsed="true" />
                                        </td>
                                        <td class="px-6 py-4">
                                            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                                                ${lh.trangThai}
                                            </span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <p class="text-sm text-gray-500 italic">Không có lịch hẹn nào đã được xác nhận.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>


            <div class="mt-8 text-center">
        <a href="${pageContext.request.contextPath}/benhnhan/dashboard.jsp"
           class="inline-block bg-blue-600 hover:bg-blue-700 text-white px-5 py-2 rounded-lg shadow transition">
           Quay lại bảng điều khiển
        </a>
    </div>
</div>
        
<jsp:include page="/layout/footer.jsp" />

</body>
</html>
