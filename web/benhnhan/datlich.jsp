<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đặt lịch khám | Bệnh viện Đa Khoa Online</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-gray-50 text-gray-800">

<!-- Header -->
<jsp:include page="/layout/header.jsp" />

<!-- Nội dung -->
<section class="container mx-auto px-4 py-20">
    <div class="max-w-3xl mx-auto bg-white p-10 rounded-2xl shadow-lg">
        <h2 class="text-3xl font-bold text-center mb-8 text-sky-700">
            <i class="fa-solid fa-calendar-check me-2"></i> Đặt Lịch Khám Bệnh
        </h2>

        <!-- Hiển thị lỗi nếu có -->
        <c:if test="${not empty requestScope.error}">
            <p class="text-red-600 text-center font-semibold mb-4">${requestScope.error}</p>
        </c:if>

        <form action="${pageContext.request.contextPath}/LichHenController" method="post" class="space-y-6">
            <input type="hidden" name="action" value="add">

            <!-- Chọn chuyên khoa -->
            <div>
                <label class="block font-semibold mb-2 text-gray-700">Chọn chuyên khoa:</label>
                <select id="khoa-select" name="khoaId" required
                        class="w-full border border-gray-300 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-sky-500">
                    <option value="">-- Vui lòng chọn khoa --</option>
                    <c:forEach var="khoa" items="${listKhoa}">
                        <option value="${khoa.idKhoa}">${khoa.tenKhoa}</option>
                    </c:forEach>
                </select>
            </div>

            <!-- Chọn bác sĩ -->
            <div>
                <label class="block font-semibold mb-2 text-gray-700">Chọn bác sĩ:</label>
                <select id="bacsi-select" name="bacSiId" required
                        class="w-full border border-gray-300 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-sky-500">
                    <option value="">-- Chọn chuyên khoa trước --</option>
                </select>
            </div>

            <!-- Ngày hẹn -->
            <div>
                <label class="block font-semibold mb-2 text-gray-700">Chọn ngày hẹn:</label>
                <input type="date" id="ngayHen" name="ngayHen" required
                       class="w-full border border-gray-300 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-sky-500">
            </div>

            <!-- Lý do khám -->
            <div>
                <label class="block font-semibold mb-2 text-gray-700">Lý do khám / Triệu chứng:</label>
                <textarea id="lyDoKham" name="lyDoKham" rows="4" required
                          class="w-full border border-gray-300 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-sky-500"
                          placeholder="Ví dụ: Đau đầu, mệt mỏi, khó ngủ..."></textarea>
            </div>

            <!-- Nút -->
            <div class="flex justify-center gap-4 pt-4">
                <button type="submit"
                        class="bg-gradient-to-r from-sky-500 to-blue-600 text-white px-8 py-3 rounded-full font-semibold shadow hover:opacity-90 transition">
                    <i class="fa-solid fa-paper-plane me-2"></i> Xác nhận đặt lịch
                </button>
                <a href="<%=request.getContextPath()%>/benhnhan/dashboard.jsp"
                   class="bg-gray-200 text-gray-700 px-8 py-3 rounded-full font-semibold hover:bg-gray-300 transition">
                    <i class="fa-solid fa-arrow-left me-2"></i> Quay lại
                </a>
            </div>
        </form>
    </div>
</section>

<!-- Footer -->
<footer class="bg-sky-700 text-white py-6 mt-12">
    <div class="container mx-auto px-4 text-center">
        <p>&copy; 2025 Bệnh viện Đa Khoa Online. Mọi quyền được bảo lưu.</p>
    </div>
</footer>

<!-- Script lọc bác sĩ -->
<script>
    const allBacSi = [
        <c:forEach var="bacsi" items="${listBacSi}" varStatus="loop">
            { id: ${bacsi.id}, ten: '${bacsi.lastName} ${bacsi.firstName}', idKhoa: ${bacsi.khoa.idKhoa} }${!loop.last ? ',' : ''}
        </c:forEach>
    ];

    const khoaSelect = document.getElementById('khoa-select');
    const bacsiSelect = document.getElementById('bacsi-select');

    khoaSelect.addEventListener('change', function () {
        const selectedKhoaId = this.value;
        bacsiSelect.innerHTML = '<option value="">-- Vui lòng chọn bác sĩ --</option>';

        if (selectedKhoaId) {
            const filteredBacSi = allBacSi.filter(bacsi => bacsi.idKhoa == selectedKhoaId);
            filteredBacSi.forEach(bacsi => {
                const option = document.createElement('option');
                option.value = bacsi.id;
                option.textContent = bacsi.ten;
                bacsiSelect.appendChild(option);
            });
        }
    });
</script>

</body>
</html>
