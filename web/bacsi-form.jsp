<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>${bacSi.id == null ? "Thêm mới bác sĩ" : "Chỉnh sửa bác sĩ"}</title>

    <!-- Google Fonts: Poppins -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet" />

    <style>
        /* Reset cơ bản */
        * {
            box-sizing: border-box;
        }

        body {
            background: linear-gradient(135deg, #71b7e6, #9b59b6);
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 40px 20px;
            color: #333;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .form-container {
            background: white;
            width: 100%;
            max-width: 600px;
            padding: 30px 40px;
            border-radius: 15px;
            box-shadow: 0 15px 25px rgba(0, 0, 0, 0.15);
            transition: transform 0.3s ease;
        }

        .form-container:hover {
            transform: translateY(-5px);
        }

        h2 {
            margin-bottom: 25px;
            font-weight: 600;
            font-size: 28px;
            text-align: center;
            color: #5a2a83;
            letter-spacing: 1px;
        }

        .error-message {
            background-color: #ff4d4d;
            color: white;
            padding: 12px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-weight: 600;
            text-align: center;
            box-shadow: 0 2px 6px rgba(255, 0, 0, 0.3);
        }

        form {
            width: 100%;
        }

        .form-group {
            margin-bottom: 18px;
            display: flex;
            flex-direction: column;
        }

        label {
            margin-bottom: 8px;
            font-weight: 600;
            color: #5a2a83;
            letter-spacing: 0.5px;
        }

        input[type="text"],
        input[type="email"],
        input[type="password"],
        input[type="number"],
        input[type="date"],
        select {
            padding: 12px 15px;
            border: 2px solid #dcdcdc;
            border-radius: 10px;
            font-size: 16px;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }

        input[type="text"]:focus,
        input[type="email"]:focus,
        input[type="password"]:focus,
        input[type="number"]:focus,
        input[type="date"]:focus,
        select:focus {
            outline: none;
            border-color: #5a2a83;
            box-shadow: 0 0 8px #5a2a83aa;
        }

        /* Radio group */
        .radio-group {
            display: flex;
            gap: 25px;
        }

        .radio-group label {
            font-weight: 500;
            color: #444;
            cursor: pointer;
        }

        .radio-group input[type="radio"] {
            margin-right: 6px;
            cursor: pointer;
        }

        /* Buttons */
        .form-actions {
            margin-top: 30px;
            display: flex;
            justify-content: space-between;
        }

        button {
            flex: 1;
            padding: 12px 0;
            border: none;
            border-radius: 10px;
            font-size: 18px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.3s ease;
            color: white;
            margin: 0 5px;
            box-shadow: 0 6px 12px rgba(90, 42, 131, 0.4);
        }

        button[type="submit"] {
            background: linear-gradient(45deg, #7b3fe4, #9b59b6);
            box-shadow: 0 8px 15px rgba(155, 89, 182, 0.6);
        }

        button[type="submit"]:hover {
            background: linear-gradient(45deg, #9b59b6, #7b3fe4);
            box-shadow: 0 12px 24px rgba(123, 63, 228, 0.8);
        }

        button.btn-cancel {
            background: #b0b0b0;
            color: #333;
            box-shadow: 0 6px 12px rgba(176, 176, 176, 0.5);
        }

        button.btn-cancel:hover {
            background: #8c8c8c;
            color: white;
            box-shadow: 0 10px 20px rgba(140, 140, 140, 0.7);
        }

        /* Responsive */
        @media (max-width: 650px) {
            .form-container {
                padding: 25px 20px;
            }

            .form-actions {
                flex-direction: column;
            }

            .form-actions button {
                margin: 8px 0;
                width: 100%;
            }
        }
    </style>
</head>

<body>
<div class="form-container">
    <h2>${bacSi.id == null ? "Thêm mới bác sĩ" : "Chỉnh sửa bác sĩ"}</h2>

    <c:if test="${not empty error}">
        <div class="error-message">${error}</div>
    </c:if>

    <form action="bacsi" method="post" accept-charset="UTF-8" autocomplete="off">
        <input type="hidden" name="id" value="${bacSi.id}"/>

        <div class="form-group">
            <label for="email">Email <span style="color:#e74c3c;">*</span></label>
            <input type="email" id="email" name="email" value="${bacSi.email}" required placeholder="Nhập email"/>
        </div>

        <div class="form-group">
            <label for="password">${bacSi.id == null ? "Mật khẩu *" : "Mật khẩu (để trống nếu không đổi)"}</label>
            <input type="password" id="password" name="password" placeholder="Nhập mật khẩu"/>
        </div>

        <div class="form-group">
            <label for="firstName">Họ</label>
            <input type="text" id="firstName" name="firstName" value="${bacSi.firstName}" placeholder="Nhập họ"/>
        </div>

        <div class="form-group">
            <label for="lastName">Tên</label>
            <input type="text" id="lastName" name="lastName" value="${bacSi.lastName}" placeholder="Nhập tên"/>
        </div>

        <div class="form-group">
            <label>Giới tính</label>
            <div class="radio-group">
                <label><input type="radio" name="gender" value="Male" ${bacSi.gender == 'Male' ? 'checked' : ''}/> Nam</label>
                <label><input type="radio" name="gender" value="Female" ${bacSi.gender == 'Female' ? 'checked' : ''}/> Nữ</label>
            </div>
        </div>

        <div class="form-group">
            <label for="phoneNumber">Số điện thoại</label>
            <input type="text" id="phoneNumber" name="phoneNumber" value="${bacSi.phoneNumber}" placeholder="Nhập số điện thoại"/>
        </div>

        <div class="form-group">
            <label for="address">Địa chỉ</label>
            <input type="text" id="address" name="address" value="${bacSi.address}" placeholder="Nhập địa chỉ"/>
        </div>

        <div class="form-group">
            <label for="birthday">Ngày sinh</label>
            <input type="date" id="birthday" name="birthday" value="${bacSi.birthday}"/>
        </div>

        <div class="form-group">
            <label for="chuyenNganh">Chuyên ngành</label>
            <input type="text" id="chuyenNganh" name="chuyenNganh" value="${bacSi.chuyenNganh}" placeholder="Nhập chuyên ngành"/>
        </div>

        <div class="form-group">
            <label for="bangCap">Bằng cấp</label>
            <input type="number" id="bangCap" name="bangCap" value="${bacSi.bangCap}" placeholder="Nhập bằng cấp"/>
        </div>

        <div class="form-group">
            <label for="kinhNghiem">Kinh nghiệm (năm)</label>
            <input type="number" id="kinhNghiem" name="kinhNghiem" value="${bacSi.kinhNghiem}" placeholder="Nhập kinh nghiệm"/>
        </div>

        <div class="form-group">
            <label for="khoaId">Khoa</label>
            <select id="khoaId" name="khoaId">
                <option value="">-- Chọn khoa --</option>
                <c:forEach var="khoa" items="${listKhoa}">
                    <option value="${khoa.id}" ${bacSi.khoa != null && bacSi.khoa.id == khoa.id ? "selected" : ""}>${khoa.tenKhoa}</option>
                </c:forEach>
            </select>
        </div>

        <div class="form-actions">
            <button type="submit">Lưu lại</button>
            <button type="button" class="btn-cancel" onclick="window.location.href='${pageContext.request.contextPath}/bacsi-list.jsp'">Huỷ</button>

        </div>
    </form>
</div>
</body>
</html>
