<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="/layout/header.jsp" />

<div class="form-container max-w-xl mx-auto mt-10 bg-white p-6 rounded shadow">
    <h2 class="text-2xl font-bold text-center mb-6 text-blue-600">
        ${bacSi == null || bacSi.userId == null ? "Thêm mới bác sĩ" : "Chỉnh sửa bác sĩ"}
    </h2>

    <form action="${pageContext.request.contextPath}/admin" method="post">
        <input type="hidden" name="entity" value="bacsi"/>
        <input type="hidden" name="action" value="save"/>
        <input type="hidden" name="id" value="${bacSi.userId}"/>

        <div class="form-group mb-3">
            <label class="block font-semibold">Email *</label>
            <input type="email" name="email" value="${bacSi.email}" required
                   class="w-full border rounded px-3 py-2"/>
        </div>

        <div class="form-group mb-3">
            <label class="block font-semibold">${bacSi.userId == null ? "Mật khẩu *" : "Mật khẩu (để trống nếu không đổi)"}</label>
            <input type="password" name="password" class="w-full border rounded px-3 py-2"/>
        </div>

        <div class="grid grid-cols-2 gap-4">
            <div>
                <label class="block font-semibold">Họ</label>
                <input type="text" name="firstName" value="${bacSi.firstName}" class="w-full border rounded px-3 py-2"/>
            </div>
            <div>
                <label class="block font-semibold">Tên</label>
                <input type="text" name="lastName" value="${bacSi.lastName}" class="w-full border rounded px-3 py-2"/>
            </div>
        </div>

        <div class="mt-3">
            <label class="block font-semibold">Giới tính</label>
            <label><input type="radio" name="gender" value="Male" ${bacSi.gender == 'Male' ? 'checked' : ''}/> Nam</label>
            <label><input type="radio" name="gender" value="Female" ${bacSi.gender == 'Female' ? 'checked' : ''}/> Nữ</label>
        </div>

        <div class="mt-3">
            <label class="block font-semibold">Khoa</label>
            <select name="khoaId" class="w-full border rounded px-3 py-2">
                <option value="">-- Chọn khoa --</option>
                <c:forEach var="khoa" items="${listKhoa}">
                    <option value="${khoa.idKhoa}" ${bacSi.khoa != null && bacSi.khoa.idKhoa == khoa.idKhoa ? "selected" : ""}>${khoa.tenKhoa}</option>
                </c:forEach>
            </select>
        </div>

        <div class="flex justify-end mt-6">
            <button type="button" onclick="window.location.href='${pageContext.request.contextPath}/admin?entity=bacsi&action=list'"
                    class="bg-gray-400 text-white px-4 py-2 rounded mr-2 hover:bg-gray-500">Hủy</button>
            <button type="submit"
                    class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Lưu</button>
        </div>
    </form>
</div>

<jsp:include page="/layout/footer.jsp" />
