<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    // Kiểm tra nếu chưa đăng nhập thì chuyển về login.jsp
    Object user = session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return; // Dừng không render tiếp trang này
    }
%>

<jsp:include page="/header.jsp" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Trang bệnh nhân</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
</head>
<body class="p-4">

<section class="info mb-4">
    <h3>Thông tin cá nhân</h3>
    <div class="card p-3 shadow-sm border-0">
        <ul class="list-group list-group-flush">
            <li class="list-group-item"><b>Mã bệnh nhân:</b> ${sessionScope.user.userId}</li>
            <li class="list-group-item"><b>Họ và tên:</b> ${sessionScope.user.firstName} ${sessionScope.user.lastName}</li>
            <li class="list-group-item"><b>Email:</b> ${sessionScope.user.email}</li>
            <li class="list-group-item"><b>Giới tính:</b> ${sessionScope.user.gender}</li>
            <li class="list-group-item"><b>Ngày sinh:</b> ${sessionScope.user.birthday}</li>
            <li class="list-group-item"><b>Số điện thoại:</b> ${sessionScope.user.phoneNumber}</li>
            <li class="list-group-item"><b>Địa chỉ:</b> ${sessionScope.user.address}</li>
        </ul>

        <div class="mt-3">
            <a href="${pageContext.request.contextPath}/benhnhan/editprofile.jsp" class="btn btn-primary">
                ✏️ Cập nhật thông tin
            </a>
            <a href="${pageContext.request.contextPath}/user?action=logout" class="btn btn-outline-danger">
                Đăng xuất
            </a>
        </div>
    </div>

    <c:if test="${not empty successMsg}">
        <div class="alert alert-success mt-3">${successMsg}</div>
    </c:if>
</section>

<section class="actions mt-4">
    <h3>Chức năng</h3>
    <button class="btn btn-success me-2" onclick="window.location.href='${pageContext.request.contextPath}/benhnhan/datlich.jsp'">
        🩺 Đặt lịch khám mới
    </button>
    <button class="btn btn-secondary" onclick="window.location.href='${pageContext.request.contextPath}/benhnhan/lichsu.jsp'">
        📖 Xem lịch sử khám
    </button>
</section>

</body>
</html>

<jsp:include page="/footer.jsp" />
