<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    // ========== KIỂM TRA SESSION==========
    Object user = session.getAttribute("user");
    if (user == null) {
        // Chưa đăng nhập -> quay lại trang login
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

%>

<jsp:include page="/layout/header.jsp" />

<div class="container p-4">
    <h1 class="text-2xl font-bold mb-4">Quản trị - Admin</h1>
    <div class="grid grid-cols-3 gap-4">
        <a href="${pageContext.request.contextPath}/admin?entity=bacsi&action=list"
           class="p-6 bg-white rounded shadow text-center hover:bg-gray-100">
            Danh sách Bác sĩ
        </a>
        <a href="${pageContext.request.contextPath}/admin?entity=khoa&action=list"
           class="p-6 bg-white rounded shadow text-center hover:bg-gray-100">
            Danh sách Khoa
        </a>
        <a href="${pageContext.request.contextPath}/admin?entity=phong&action=list"
           class="p-6 bg-white rounded shadow text-center hover:bg-gray-100">
            Danh sách Phòng
        </a>
    </div>
</div>

<jsp:include page="/layout/footer.jsp" />
