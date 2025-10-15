<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    Object user = session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<jsp:include page="/layout/header.jsp" />

<div class="container mx-auto px-6 py-10 text-center">
    <h1 class="text-3xl font-bold mb-8 text-gray-900">
        Quản trị hệ thống - <span class="text-blue-700">Admin</span><br>
    </h1>
            
    <div class="flex justify-end mb-4">
        <a href="${pageContext.request.contextPath}/admin?entity=bacsi&action=list" class="btn btn-primary">Danh sách Bác sĩ</a>
        <a href="${pageContext.request.contextPath}/admin?entity=khoa&action=list" class="btn btn-primary">Danh sách Khoa</a>
        <a href="${pageContext.request.contextPath}/admin?entity=phong&action=list" class="btn btn-primary">Danh sách Phòng</a>
    </div>
</div>

<jsp:include page="/layout/footer.jsp" />
