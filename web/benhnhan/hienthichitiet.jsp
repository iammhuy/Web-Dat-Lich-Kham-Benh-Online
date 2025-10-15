<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="app.business.giaodich.LichHen" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%-- Nhận đối tượng lichHen duy nhất từ servlet --%>
<c:set var="lh" value="${requestScope.lichHen}" />
//<c:set var="tenPhong" value="${requestScope.tenPhong}" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết lịch hẹn #${lh.lichHenId}</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 p-6">

<div class="max-w-3xl mx-auto bg-white p-8 rounded-lg shadow-md">
    <h1 class="text-3xl font-bold mb-6 border-b pb-4">Chi tiết lịch hẹn</h1>

    <c:if test="${not empty lh}">
        <div class="space-y-4 text-gray-700">
            <p><strong>Mã lịch hẹn:</strong> ${lh.lichHenId}</p>
            <p><strong>Bệnh nhân:</strong> ${lh.benhNhan.lastName} ${lh.benhNhan.firstName}</p>
            <p><strong>Bác sĩ:</strong> ${lh.bacSi.lastName} ${lh.bacSi.firstName}</p>
            <p><strong>Chuyên khoa:</strong> ${lh.bacSi.chuyenNganh}</p>
            <p><strong>Ngày hẹn:</strong> <fmt:formatDate value="${lh.ngayHen}" pattern="dd/MM/yyyy" /></p>
            <p><strong>Giờ hẹn:</strong>
                <fmt:formatDate value="${lh.caKham.gioBatDau}" pattern="HH:mm" /> -
                <fmt:formatDate value="${lh.caKham.gioKetThuc}" pattern="HH:mm" />
            </p>
            <p><strong>Phòng khám:</strong> ${tenPhong}</p>
            <p><strong>Lý do khám:</strong> ${lh.lyDoKham}</p>
            <p><strong>Trạng thái:</strong>
                <span class="font-semibold
                    <c:if test='${lh.trangThai == "Đã duyệt"}'>text-green-600</c:if>
                    <c:if test='${lh.trangThai == "Chờ xác nhận"}'>text-yellow-600</c:if>
                    <c:if test='${lh.trangThai == "Đã hủy"}'>text-red-600</c:if>
                ">${lh.trangThai}</span>
            </p>
        </div>
    </c:if>

    <div class="mt-8 border-t pt-6">
        <a href="${pageContext.request.contextPath}/xem-lich-hen"
           class="px-5 py-2 bg-gray-600 text-white font-semibold rounded-lg hover:bg-gray-700 transition">
           ← Quay lại danh sách
        </a>
    </div>
</div>

</body>
</html>