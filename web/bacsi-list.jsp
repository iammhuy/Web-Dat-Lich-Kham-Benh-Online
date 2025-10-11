<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Danh sách Bác sĩ</title>
    <style>
        /* Table Styling */
table {
    width: 100%;
    border-collapse: collapse;
    background-color: white;
    border-radius: 10px;
    overflow: hidden;
    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
    font-size: 15px;
    margin-top: 20px;
}

thead {
    background-color: #7b3fe4;
    color: white;
    text-align: left;
}

th, td {
    padding: 14px 18px;
    border-bottom: 1px solid #ddd;
}

tbody tr:hover {
    background-color: #f4f4f4;
}

a {
    color: #7b3fe4;
    text-decoration: none;
    font-weight: 500;
}

a:hover {
    text-decoration: underline;
}

/* "Thêm bác sĩ mới" button */
a.add-button {
    display: inline-block;
    background: linear-gradient(45deg, #7b3fe4, #9b59b6);
    color: white;
    padding: 12px 20px;
    border-radius: 8px;
    font-weight: 600;
    box-shadow: 0 6px 15px rgba(155, 89, 182, 0.4);
    transition: background 0.3s ease, transform 0.2s ease;
    text-align: center;
}

a.add-button:hover {
    background: linear-gradient(45deg, #9b59b6, #7b3fe4);
    transform: translateY(-2px);
}

/* Table responsive */
@media (max-width: 768px) {
    table, thead, tbody, th, td, tr {
        display: block;
    }

    thead tr {
        display: none;
    }

    tr {
        margin-bottom: 15px;
        background: white;
        border-radius: 10px;
        box-shadow: 0 4px 10px rgba(0,0,0,0.08);
        padding: 10px;
    }

    td {
        padding: 10px 15px;
        border: none;
        position: relative;
    }

    td::before {
        content: attr(data-label);
        font-weight: 600;
        color: #7b3fe4;
        position: absolute;
        left: 15px;
        top: 10px;
        font-size: 14px;
        text-transform: uppercase;
    }
}

    </style>
</head>
<body>
    <h2>Danh sách Bác sĩ</h2>
    <a href="bacsi?action=new">Thêm bác sĩ mới</a>
    <br/><br/>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Email</th>
                <th>Họ Tên</th>
                <th>Chuyên ngành</th>
                <th>Bằng cấp</th>
                <th>Kinh nghiệm (năm)</th>
                <th>Khóa</th>
                <th>Thao tác</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="bacSi" items="${listBacSi}">
                <tr>
                    <td>${bacSi.id}</td>
                    <td>${bacSi.email}</td>
                    <td>${bacSi.firstName} ${bacSi.lastName}</td>
                    <td>${bacSi.chuyenNganh}</td>
                    <td>${bacSi.bangCap}</td>
                    <td>${bacSi.kinhNghiem}</td>
                    <td>${bacSi.khoa != null ? bacSi.khoa.tenKhoa : ''}</td>
                    <td>
                        <a href="bacsi?action=edit&id=${bacSi.id}">Sửa</a> |
                        <a href="bacsi?action=delete&id=${bacSi.id}" onclick="return confirm('Bạn có chắc muốn xóa?')">Xóa</a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty listBacSi}">
                <tr><td colspan="9" style="text-align:center;">Không có dữ liệu</td></tr>
            </c:if>
        </tbody>
    </table>
</body>
</html>
