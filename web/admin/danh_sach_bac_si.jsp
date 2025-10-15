<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="/layout/header.jsp" />

<%
    Object user = session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<div class="container mx-auto mt-10">
    <h2 class="text-2xl font-bold text-center mb-6 text-blue-600">Danh sách bác sĩ</h2>
    
    <div class="flex justify-end mb-4">
        <a href="${pageContext.request.contextPath}/admin/index.jsp" class="btn btn-primary">Quay lại</a>
        <a href="${pageContext.request.contextPath}/admin?entity=bacsi&action=form" class="btn btn-primary">➕ Thêm bác sĩ</a>
    </div>

    <table class="min-w-full bg-white shadow-lg rounded-lg">
        <thead>
        <tr class="bg-blue-100 text-left text-gray-700">
            <th class="py-2 px-4">ID</th>
            <th class="py-2 px-4">Họ tên</th>
            <th class="py-2 px-4">Email</th>
            <th class="py-2 px-4">Khoa</th>
            <th class="py-2 px-4">Thao tác</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="b" items="${listBacSi}">
            <tr class="border-t hover:bg-gray-50">
                <td class="py-2 px-4">${b.userId}</td>
                <td class="py-2 px-4">${b.firstName} ${b.lastName}</td>
                <td class="py-2 px-4">${b.email}</td>
                <td class="py-2 px-4">${b.khoa.tenKhoa}</td>
                <td class="py-2 px-4">
                    <a href="${pageContext.request.contextPath}/admin?entity=bacsi&action=form&id=${b.userId}"
                       class="text-blue-500 hover:underline">Sửa</a>
                    |
                    <a href="${pageContext.request.contextPath}/admin?entity=bacsi&action=delete&id=${b.userId}"
                       class="text-red-500 hover:underline"
                       onclick="return confirm('Bạn có chắc muốn xóa bác sĩ này không?')">Xóa</a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<jsp:include page="/layout/footer.jsp" />
