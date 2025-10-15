<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="/layout/header.jsp" />

<!-- Nền tổng thể -->
<div class="min-h-screen bg-gray-50 py-10 px-4 sm:px-6 lg:px-8">
  <!-- Form container -->
  <div>
    <h2 class="text-3xl font-bold text-center mb-8 text-blue-700">
      ${bacSi == null || bacSi.userId == null ? "Thêm mới bác sĩ" : "Chỉnh sửa bác sĩ"}
    </h2>

    <form action="${pageContext.request.contextPath}/admin" method="post" class="space-y-5">
      <input type="hidden" name="entity" value="bacsi"/>
      <input type="hidden" name="action" value="save"/>
      <input type="hidden" name="id" value="${bacSi.userId}"/>

      <!-- Email & Password -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div>
          <label class="block font-semibold mb-1">Email *</label>
          <input type="email" name="email" value="${bacSi.email}" required
                 class="w-full border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-400 focus:outline-none"/>
        </div>
        <div>
          <label class="block font-semibold mb-1">${bacSi.userId == null ? "Mật khẩu *" : "Mật khẩu (để trống nếu không đổi)"}</label>
          <input type="password" name="password"
                 class="w-full border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-400 focus:outline-none"/>
        </div>
      </div>

      <!-- Họ và Tên -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div>
          <label class="block font-semibold mb-1">Họ</label>
          <input type="text" name="firstName" value="${bacSi.firstName}"
                 class="w-full border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-400 focus:outline-none"/>
        </div>
        <div>
          <label class="block font-semibold mb-1">Tên</label>
          <input type="text" name="lastName" value="${bacSi.lastName}"
                 class="w-full border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-400 focus:outline-none"/>
        </div>
      </div>

      <!-- Ngày sinh & SĐT -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div>
          <label class="block font-semibold mb-1">Ngày sinh</label>
          <input type="date" name="birthday" value="${bacSi.birthday}"
                 class="w-full border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-400 focus:outline-none"/>
        </div>
        <div>
          <label class="block font-semibold mb-1">Số điện thoại</label>
          <input type="text" name="phoneNumber" value="${bacSi.phoneNumber}"
                 class="w-full border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-400 focus:outline-none"/>
        </div>
      </div>

      <!-- Địa chỉ -->
      <div>
        <label class="block font-semibold mb-1">Địa chỉ</label>
        <input type="text" name="address" value="${bacSi.address}"
               class="w-full border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-400 focus:outline-none"/>
      </div>

      <!-- Giới tính -->
      <div>
        <label class="block font-semibold mb-1">Giới tính</label>
        <div class="flex items-center gap-6">
          <label><input type="radio" name="gender" value="Male" ${bacSi.gender == 'Male' ? 'checked' : ''}/> Nam</label>
          <label><input type="radio" name="gender" value="Female" ${bacSi.gender == 'Female' ? 'checked' : ''}/> Nữ</label>
        </div>
      </div>

      <!-- Chuyên ngành & Bằng cấp -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div>
          <label class="block font-semibold mb-1">Chuyên ngành</label>
          <input type="text" name="chuyenNganh" value="${bacSi.chuyenNganh}"
                 class="w-full border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-400 focus:outline-none"/>
        </div>
        <div>
          <label class="block font-semibold mb-1">Bằng cấp</label>
          <input type="text" name="bangCap" value="${bacSi.bangCap}"
                 class="w-full border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-400 focus:outline-none"/>
        </div>
      </div>

      <!-- Kinh nghiệm & Chi phí -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div>
          <label class="block font-semibold mb-1">Kinh nghiệm (năm)</label>
          <input type="number" name="kinhNghiem" value="${bacSi.kinhNghiem}"
                 class="w-full border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-400 focus:outline-none"/>
        </div>
        <div>
          <label class="block font-semibold mb-1">Chi phí khám (VNĐ)</label>
          <input type="number" step="1000" name="chiPhiKham" value="${bacSi.chiPhiKham}"
                 class="w-full border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-400 focus:outline-none"/>
        </div>
      </div>

      <!-- Khoa -->
      <div>
        <label class="block font-semibold mb-1">Khoa</label>
        <select name="khoaId"
                class="w-full border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-400 focus:outline-none">
          <option value="">-- Chọn khoa --</option>
          <c:forEach var="khoa" items="${listKhoa}">
            <option value="${khoa.idKhoa}" ${bacSi.khoa != null && bacSi.khoa.idKhoa == khoa.idKhoa ? "selected" : ""}>
              ${khoa.tenKhoa}
            </option>
          </c:forEach>
        </select>
      </div>

      <!-- Buttons -->
      <div class="flex justify-end gap-3 pt-6 border-t">
        <button type="button"
                onclick="window.location.href='${pageContext.request.contextPath}/admin?entity=bacsi&action=list'"
                class="px-5 py-2 bg-gray-300 text-gray-800 rounded-lg hover:bg-gray-400 transition">Hủy</button>
        <button type="submit"
                class="px-5 py-2 bg-blue-600 btn btn-primary font-semibold rounded-lg hover:bg-blue-700 transition">Lưu</button>
      </div>
    </form>
  </div>
</div>

<jsp:include page="/layout/footer.jsp" />
