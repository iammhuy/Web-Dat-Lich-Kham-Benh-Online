<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>Danh Sách Lịch Hẹn</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f5f5f5; margin: 30px; }
        h2 { color: #4CAF50; text-align: center; }
        table { width: 100%; border-collapse: collapse; background: white; margin-bottom: 30px; }
        th, td { padding: 10px; border: 1px solid #ddd; text-align: center; }
        th { background-color: #4CAF50; color: white; }
        tr:nth-child(even) { background-color: #f2f2f2; }
        .status-wait { color: orange; }
        .status-ok { color: green; }
        a.btn { background: #4CAF50; color: white; padding: 6px 12px; border-radius: 4px; text-decoration: none; }
        a.btn:hover { background: #45a049; }
    </style>
</head>
<body>
    <h2>📅 Danh Sách Lịch Hẹn Của Bạn</h2>

    <h3>⏳ Lịch Chưa Xác Nhận</h3>
    <table>
        <tr>
            <th>Bác sĩ</th>
            <th>Chuyên khoa</th>
            <th>Ngày hẹn</th>
            <th>Ca khám</th>
            <th>Lý do</th>
            <th>Chi phí</th>
            <th>Trạng thái</th>
        </tr>
        <c:forEach var="lh" items="${lichChuaXN}">
            <tr>
                <td>${lh.bacSi.lastName} ${lh.bacSi.firstName}</td>
                <td>${lh.bacSi.khoa.tenKhoa}</td>
                <td><fmt:formatDate value='${lh.ngayHen}' pattern='yyyy-MM-dd'/></td>
                <td>
                    <c:choose>
                        <c:when test="${lh.caKham != null}">
                            ${lh.caKham.tenCa} (
                            <fmt:formatDate value='${lh.caKham.gioBatDau}' pattern='HH:mm'/> -
                            <fmt:formatDate value='${lh.caKham.gioKetThuc}' pattern='HH:mm'/>
                            )
                        </c:when>
                        <c:otherwise>Chưa chọn ca</c:otherwise>
                    </c:choose>
                </td>
                <td>${lh.lyDoKham}</td>
                <td>${lh.chiPhi}</td>
                <td class="status-wait">${lh.trangThai}</td>
            </tr>
        </c:forEach>
    </table>

    <h3>✅ Lịch Đã Xác Nhận (Đã Thanh Toán)</h3>
    <table>
        <tr>
            <th>Bác sĩ</th>
            <th>Chuyên khoa</th>
            <th>Ngày hẹn</th>
            <th>Ca khám</th>
            <th>Lý do</th>
            <th>Chi phí</th>
            <th>Trạng thái</th>
        </tr>
        <c:forEach var="lh" items="${lichDaXN}">
            <tr>
                <td>${lh.bacSi.lastName} ${lh.bacSi.firstName}</td>
                <td>${lh.bacSi.khoa.tenKhoa}</td>
                <td><fmt:formatDate value='${lh.ngayHen}' pattern='yyyy-MM-dd'/></td>
                <td>
                    <c:choose>
                        <c:when test="${lh.caKham != null}">
                            ${lh.caKham.tenCa} (
                            <fmt:formatDate value='${lh.caKham.gioBatDau}' pattern='HH:mm'/> -
                            <fmt:formatDate value='${lh.caKham.gioKetThuc}' pattern='HH:mm'/>
                            )
                        </c:when>
                    </c:choose>
                </td>
                <td>${lh.lyDoKham}</td>
                <td>${lh.chiPhi}</td>
                <td class="status-ok">${lh.trangThai}</td>
            </tr>
        </c:forEach>
    </table>

    <div style="text-align:center; margin-top:20px;">
        <a href="${pageContext.request.contextPath}/benhnhan/dashboard.jsp" class="btn">← Quay lại Trang Chính</a>
    </div>
</body>
</html>
