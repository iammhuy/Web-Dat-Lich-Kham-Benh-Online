<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Xác Nhận Đặt Lịch Khám | Bệnh viện Đa Khoa Online</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-gray-50 text-gray-800">

<!-- Header -->
<jsp:include page="/layout/header.jsp" />

<section class="container mx-auto px-4 py-20">
    <div class="max-w-2xl mx-auto bg-white p-10 rounded-2xl shadow-lg">
        <h2 class="text-3xl font-bold text-center text-green-600 mb-10">
            <i class="fa-solid fa-circle-check me-2"></i> Đặt Lịch Thành Công!
        </h2>

        <div class="space-y-4 text-lg bg-gray-50 p-6 rounded-xl border">
            <p><span class="font-semibold text-sky-700"><i class="fa-solid fa-user me-2"></i>Bệnh nhân:</span>
                <c:out value="${sessionScope.lichHenVuaDat.benhNhan.firstName}"/>
                <c:out value="${sessionScope.lichHenVuaDat.benhNhan.lastName}"/>
            </p>

            <p><span class="font-semibold text-sky-700"><i class="fa-solid fa-user-doctor me-2"></i>Bác sĩ:</span>
                <c:out value="${sessionScope.lichHenVuaDat.bacSi.lastName}"/>
                <c:out value="${sessionScope.lichHenVuaDat.bacSi.firstName}"/>
            </p>

            <p><span class="font-semibold text-sky-700"><i class="fa-solid fa-hospital me-2"></i>Chuyên khoa:</span>
                <c:out value="${sessionScope.lichHenVuaDat.bacSi.khoa.tenKhoa}"/>
            </p>

            <p><span class="font-semibold text-sky-700"><i class="fa-solid fa-calendar-day me-2"></i>Ngày hẹn:</span>
                <fmt:formatDate value="${sessionScope.lichHenVuaDat.ngayHen}" pattern="dd/MM/yyyy"/>
            </p>

            <p><span class="font-semibold text-sky-700"><i class="fa-solid fa-file-medical me-2"></i>Lý do khám:</span>
                <c:out value="${sessionScope.lichHenVuaDat.lyDoKham}"/>
            </p>

            <p><span class="font-semibold text-sky-700"><i class="fa-solid fa-money-bill me-2"></i>Chi phí khám:</span>
                <fmt:formatNumber value="${sessionScope.lichHenVuaDat.chiPhi}" type="currency" currencySymbol="₫"/>
            </p>

            <p><span class="font-semibold text-sky-700"><i class="fa-solid fa-circle-info me-2"></i>Trạng thái:</span>
                <span class="text-orange-500 font-medium"><c:out value="${sessionScope.lichHenVuaDat.trangThai}"/></span>
            </p>
        </div>

        <form action="${pageContext.request.contextPath}/ThanhToanController" method="post" class="text-center mt-10">
            <input type="hidden" name="action" value="confirm">
            <input type="hidden" name="lichHenId" value="${sessionScope.lichHenVuaDat.lichHenId}">
            
            <button type="submit"
                    class="bg-gradient-to-r from-green-500 to-emerald-600 text-white px-8 py-3 rounded-full font-semibold shadow hover:opacity-90 transition">
                <i class="fa-solid fa-credit-card me-2"></i> Xác nhận & Thanh toán
            </button>

                <a href="${pageContext.request.contextPath}/LichHenController?action=form"
                    class="ml-4 bg-gray-200 text-gray-700 px-8 py-3 rounded-full font-semibold hover:bg-gray-300 transition">
                    <i class="fa-solid fa-arrow-left me-2"></i> Quay lại
                </a>

        </form>
    </div>
</section>

<footer class="bg-sky-700 text-white py-6 mt-12">
    <div class="container mx-auto px-4 text-center">
        <p>&copy; 2025 Bệnh viện Đa Khoa Online. Mọi quyền được bảo lưu.</p>
    </div>
</footer>

</body>
</html>
