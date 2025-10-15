<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/layout/header.jsp" />
<%
    // ========== KIỂM TRA SESSION==========
    Object user = session.getAttribute("user");
    if (user == null) {
        // Chưa đăng nhập -> quay lại trang login
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

%>
<div class="container p-4">
    <div class="flex justify-between items-center mb-4">
        <h2 class="text-xl font-bold">Danh sách Khoa</h2>
        <a href="${pageContext.request.contextPath}/admin/index.jsp" class="btn btn-primary">Quay lại</a>
        <a href="${pageContext.request.contextPath}/admin?entity=khoa&action=new" class="btn btn-primary">+ Thêm Khoa</a>
    </div>

    <table class="table-auto w-full bg-white">
        <thead>
            <tr><th class="px-4 py-2">ID</th><th class="px-4 py-2">Tên Khoa</th><th class="px-4 py-2">Mô tả</th><th class="px-4 py-2">Hành động</th></tr>
        </thead>
        <tbody>
            <c:forEach var="k" items="${listKhoa}">
                <tr class="border-t">
                    <td class="px-4 py-2">${k.idKhoa}</td>
                    <td class="px-4 py-2">${k.tenKhoa}</td>
                    <td class="px-4 py-2">${k.moTa}</td>
                    <td class="px-4 py-2">
                        <a href="${pageContext.request.contextPath}/admin?entity=khoa&action=edit&id=${k.idKhoa}">Sửa</a> |
                        <a href="${pageContext.request.contextPath}/admin?entity=khoa&action=delete&id=${k.idKhoa}" onclick="return confirm('Xóa khoa?')">Xóa</a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty listKhoa}">
                <tr><td colspan="4" class="text-center p-4">Không có khoa.</td></tr>
            </c:if>
        </tbody>
    </table>
</div>
<jsp:include page="/layout/footer.jsp" />
