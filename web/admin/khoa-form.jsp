<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/layout/header.jsp" />

<%
    // ========== KIỂM TRA SESSION ==========
    Object user = session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<div class="container mx-auto mt-10 max-w-lg">
    <h2 class="text-2xl font-bold text-center mb-6 text-blue-600">
        <c:choose>
            <c:when test="${not empty khoa}">Chỉnh sửa Khoa</c:when>
            <c:otherwise>Thêm Khoa mới</c:otherwise>
        </c:choose>
    </h2>

    <form action="${pageContext.request.contextPath}/admin" method="POST"
          class="bg-white shadow-lg rounded-lg p-6 space-y-4">

        <!-- Phần ẩn để xác định hành động -->
        <input type="hidden" name="entity" value="khoa" />
        <input type="hidden" name="action" value="save" />

        <c:if test="${not empty khoa}">
            <input type="hidden" name="id" value="${khoa.idKhoa}" />
        </c:if>

        <div>
            <label class="block text-gray-700 font-medium mb-1">Tên Khoa</label>
            <input type="text" name="tenKhoa" value="${khoa.tenKhoa}" required
                   class="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:outline-none" />
        </div>

        <div>
            <label class="block text-gray-700 font-medium mb-1">Mô tả</label>
            <textarea name="moTa" rows="3"
                      class="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:outline-none">${khoa.moTa}</textarea>
        </div>

        <div class="flex justify-between items-center mt-6">
            <a href="${pageContext.request.contextPath}/admin?entity=khoa&action=list"
               class="px-4 py-2 bg-gray-300 text-gray-800 rounded hover:bg-gray-400">⬅ Quay lại</a>

            <button type="submit"
                    class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">💾 Lưu lại</button>
        </div>
    </form>
</div>

<jsp:include page="/layout/footer.jsp" />
