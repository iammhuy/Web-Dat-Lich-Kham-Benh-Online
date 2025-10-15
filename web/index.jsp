<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang chủ | Bệnh viện Đa Khoa Online</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-gray-50 text-gray-800">

<!-- Header -->
<jsp:include page="/layout/header.jsp" />

<!-- Hero Section -->
<section class="relative bg-gradient-to-r from-sky-500 to-blue-600 text-white">
    <div class="container mx-auto px-4 py-20 text-center">
        <h1 class="text-4xl font-bold mb-4">Đặt lịch khám bệnh nhanh chóng - Tiện lợi - Chính xác</h1>
        <p class="text-lg mb-6">Hệ thống Bệnh viện Đa khoa Online giúp bạn đặt lịch, theo dõi kết quả, và quản lý hồ sơ sức khỏe dễ dàng.</p>
        <a href="<%=request.getContextPath()%>/login.jsp" 
           class="bg-white text-sky-600 px-6 py-3 rounded-full font-semibold shadow hover:bg-gray-100 transition">
            Đặt lịch ngay
        </a>
    </div>
</section>

<!-- Dịch vụ nổi bật -->
<section class="container mx-auto px-4 py-16">
    <h2 class="text-3xl font-bold text-center mb-12 text-sky-700">Dịch vụ nổi bật</h2>
    <div class="grid md:grid-cols-3 gap-8">
        <div class="bg-white p-6 rounded-2xl shadow hover:shadow-lg transition">
            <div class="text-sky-600 text-4xl mb-4 text-center"><i class="fa-solid fa-stethoscope"></i></div>
            <h3 class="text-xl font-semibold text-center mb-2">Khám tổng quát</h3>
            <p class="text-gray-600 text-center">Đặt lịch khám tổng quát với đội ngũ bác sĩ uy tín, nhanh chóng và chính xác.</p>
        </div>
        <div class="bg-white p-6 rounded-2xl shadow hover:shadow-lg transition">
            <div class="text-sky-600 text-4xl mb-4 text-center"><i class="fa-solid fa-user-doctor"></i></div>
            <h3 class="text-xl font-semibold text-center mb-2">Chuyên khoa sâu</h3>
            <p class="text-gray-600 text-center">Khám chuyên khoa tim mạch, thần kinh, da liễu, và nhiều chuyên ngành khác.</p>
        </div>
        <div class="bg-white p-6 rounded-2xl shadow hover:shadow-lg transition">
            <div class="text-sky-600 text-4xl mb-4 text-center"><i class="fa-solid fa-hospital"></i></div>
            <h3 class="text-xl font-semibold text-center mb-2">Theo dõi hồ sơ</h3>
            <p class="text-gray-600 text-center">Tra cứu kết quả khám và quản lý hồ sơ sức khỏe mọi lúc mọi nơi.</p>
        </div>
    </div>
</section>

<!-- Footer -->
<footer class="bg-sky-700 text-white py-6 mt-12">
    <div class="container mx-auto px-4 text-center">
        <p>&copy; 2025 Bệnh viện Đa Khoa Online. Mọi quyền được bảo lưu.</p>
    </div>
</footer>

</body>
</html>
