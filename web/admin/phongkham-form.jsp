<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="/layout/header.jsp" />

<%
    // session check
    Object user = session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<div class="container p-4 max-w-2xl mx-auto">
    <c:set var="isNew" value="${empty phong.phongId}" />
    <h2 class="text-2xl font-bold mb-4">${isNew ? "Thêm Phòng khám" : "Chỉnh sửa Phòng khám"}</h2>

    <c:if test="${not empty error}">
        <div class="mb-3 p-3 bg-red-50 text-red-700 rounded">${error}</div>
    </c:if>

    <!-- Form gửi tới servlet /admin; đảm bảo controller xử lý entity=phong, action=save -->
    <form action="${pageContext.request.contextPath}/admin" method="post" accept-charset="UTF-8">
        <input type="hidden" name="entity" value="phong"/>
        <input type="hidden" name="action" value="save"/>
        <input type="hidden" name="id" value="${phong.phongId}" />

        <div class="mb-3">
            <label class="block font-semibold mb-1">Tên phòng</label>
            <input type="text" name="tenPhong" value="${phong.tenPhong}" required
                   class="w-full border rounded px-3 py-2" />
        </div>

        <div class="mb-3">
            <label class="block font-semibold mb-1">Khoa</label>
            <select name="khoaId" class="w-full border rounded px-3 py-2" required>
                <option value="">-- Chọn khoa --</option>
                <c:forEach var="k" items="${listKhoa}">
                    <option value="${k.idKhoa}"
                      <c:if test="${phong.khoa != null && phong.khoa.idKhoa == k.idKhoa}">selected</c:if>>
                      ${k.tenKhoa}
                    </option>
                </c:forEach>
            </select>
        </div>

        <div class="flex justify-end gap-3 mt-4">
            <a href="${pageContext.request.contextPath}/admin?entity=phong&action=list" class="px-4 py-2 bg-gray-300 rounded">Hủy</a>
            <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded">
                ${isNew ? "Thêm" : "Cập nhật"}
            </button>
        </div>
    </form>
</div>

<jsp:include page="/layout/footer.jsp" />
