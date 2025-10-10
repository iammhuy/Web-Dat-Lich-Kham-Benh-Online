<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/header.jsp" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cập nhật thông tin cá nhân</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
</head>
<body class="p-4">

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card shadow-sm border-0">
                <div class="card-body">
                    <h3 class="text-center text-primary mb-4">Cập nhật thông tin cá nhân</h3>

                    <form action="${pageContext.request.contextPath}/user" method="post" accept-charset="UTF-8">
                        <input type="hidden" name="action" value="editprofile"/>

                        <div class="mb-3">
                            <label>Email (không thể thay đổi):</label>
                            <input type="email" class="form-control" value="${sessionScope.user.email}" readonly/>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label>Họ:</label>
                                <input name="firstName" class="form-control" value="${sessionScope.user.firstName}" required/>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label>Tên:</label>
                                <input name="lastName" class="form-control" value="${sessionScope.user.lastName}" required/>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label>Giới tính:</label>
                                <select name="gender" class="form-select">
                                    <option value="Nam" <c:if test="${sessionScope.user.gender eq 'Nam'}">selected</c:if>>Nam</option>
                                    <option value="Nữ" <c:if test="${sessionScope.user.gender eq 'Nữ'}">selected</c:if>>Nữ</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label>Ngày sinh:</label>
                                <input type="date" name="birthday" class="form-control"
                                       value="${sessionScope.user.birthday}"/>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label>Số điện thoại:</label>
                            <input name="phoneNumber" class="form-control" value="${sessionScope.user.phoneNumber}"/>
                        </div>

                        <div class="mb-3">
                            <label>Địa chỉ:</label>
                            <input name="address" class="form-control" value="${sessionScope.user.address}"/>
                        </div>

                        <div class="d-flex justify-content-between">
                            <a href="${pageContext.request.contextPath}/benhnhan/index.jsp" class="btn btn-secondary">
                                ← Quay lại
                            </a>
                            <button type="submit" class="btn btn-success">💾 Lưu thay đổi</button>
                        </div>
                    </form>

                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
<jsp:include page="/footer.jsp" />
