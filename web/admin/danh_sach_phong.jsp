<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="/layout/header.jsp" />

<%
    // ========== KIỂM TRA SESSION ==========
    Object user = session.getAttribute("user");
    if (user == null) {
        // Chưa đăng nhập -> quay lại trang login
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<div class="container p-4">
    <div class="flex justify-between items-center mb-4">
        <h2 class="text-xl font-bold">Danh sách Phòng khám</h2>
        <!-- Link dẫn sang controller để show form "new" -->
        <a href="${pageContext.request.contextPath}/admin/index.jsp" class="btn btn-primary">Quay lại</a>
        <a href="${pageContext.request.contextPath}/admin?entity=phong&action=new" class="btn btn-primary">+ Thêm Phòng</a>
    </div>

    <table class="table-auto w-full bg-white">
        <thead>
            <tr>
                <th class="px-4 py-2">ID</th>
                <th class="px-4 py-2">Tên Phòng</th>
                <th class="px-4 py-2">Thuộc Khoa</th>
                <th class="px-4 py-2">Hành động</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="p" items="${listPhong}">
                <tr class="border-t">
                    <td class="px-4 py-2">${p.phongId}</td>
                    <td class="px-4 py-2">${p.tenPhong}</td>
                    <td class="px-4 py-2">${p.khoa != null ? p.khoa.tenKhoa : ''}</td>
                    <td class="px-4 py-2">
                        <!-- Sửa: điều hướng tới form (controller sẽ load phòng và listKhoa rồi forward) -->
                        <a href="${pageContext.request.contextPath}/admin?entity=phong&action=edit&id=${p.phongId}" class="text-blue-500 hover:underline">Sửa</a>
                        &nbsp;|&nbsp;
                        <a href="${pageContext.request.contextPath}/admin?entity=phong&action=delete&id=${p.phongId}"
                           class="text-red-500 hover:underline"
                           onclick="return confirm('Bạn có chắc muốn xóa phòng này không?')">Xóa</a>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty listPhong}">
                <tr>
                    <td colspan="4" class="text-center p-4">Không có phòng.</td>
                </tr>
            </c:if>
        </tbody>
    </table>
</div>

<jsp:include page="/layout/footer.jsp" />
