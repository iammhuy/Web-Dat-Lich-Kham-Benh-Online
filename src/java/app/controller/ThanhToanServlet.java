/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package app.controller;

import app.business.giaodich.PhuongThuc;
import app.business.giaodich.ThanhToan;
import app.database.ThanhToanDB;
import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.io.PrintWriter; 
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.vnpay.common.Config; 
public class ThanhToanServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Giả sử bạn lấy các thông tin này từ form hoặc session
        int lichHenId = 1; // VÍ DỤ - Thay bằng cách lấy động
        BigDecimal soTien = new BigDecimal("10000"); // VÍ DỤ - Lấy chi phí thực tế

        ThanhToan thanhToan = new ThanhToan();
        thanhToan.setLichHenId(lichHenId);
        thanhToan.setSoTien(soTien);
        thanhToan.setPhuongThuc(PhuongThuc.VNPAY);

        int thanhToanId = ThanhToanDB.createPendingPayment(thanhToan);

        if (thanhToanId == 0) {
            request.setAttribute("message", "Lỗi khi khởi tạo thanh toán. Vui lòng thử lại.");
            request.getRequestDispatcher("/payment_error.jsp").forward(request, response);
            return;
        }

        long amount = soTien.longValue() * 100;
        
        Map<String, String> vnp_Params = new HashMap<>();
        vnp_Params.put("vnp_Version", Config.vnp_Version);
        vnp_Params.put("vnp_Command", "pay");
        vnp_Params.put("vnp_TmnCode", Config.vnp_TmnCode);
        vnp_Params.put("vnp_Amount", String.valueOf(amount));
        vnp_Params.put("vnp_CurrCode", "VND");
        vnp_Params.put("vnp_TxnRef", String.valueOf(thanhToanId));
        vnp_Params.put("vnp_OrderInfo", "Thanh toan lich hen " + lichHenId);
        vnp_Params.put("vnp_OrderType", "other");
        vnp_Params.put("vnp_Locale", "vn");
        vnp_Params.put("vnp_ReturnUrl", Config.vnp_ReturnUrl);
        vnp_Params.put("vnp_IpAddr", request.getRemoteAddr());
        vnp_Params.put("vnp_CreateDate", Config.getCurrentDate());

        List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();
        Iterator<String> itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = itr.next();
            String fieldValue = vnp_Params.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                hashData.append(fieldName);
                hashData.append('=');
                hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()));
                query.append('=');
                query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                if (itr.hasNext()) {
                    query.append('&');
                    hashData.append('&');
                }
            }
        }
        String queryUrl = query.toString();
        String vnp_SecureHash = Config.hmacSHA512(Config.vnp_HashSecret, hashData.toString());
        queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;
        String paymentUrl = Config.vnp_PayUrl + "?" + queryUrl;

        response.sendRedirect(paymentUrl);
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String action = request.getParameter("action");
    if (action != null && action.equals("vnpay_return")) {
        // Có thể thêm bước xác thực checksum ở đây để tăng bảo mật
        
        String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
        
        if ("00".equals(vnp_ResponseCode)) {
            // Giao dịch thành công
            request.setAttribute("message", "Thanh toán thành công!");
            // Chuyển hướng tới trang JSP hiển thị thành công
            request.getRequestDispatcher("/payment_success.jsp").forward(request, response);
        } else {
            // Giao dịch thất bại
            request.setAttribute("message", "Thanh toán thất bại. Vui lòng thử lại.");
            // Chuyển hướng tới trang JSP hiển thị thất bại
            request.getRequestDispatcher("/payment_error.jsp").forward(request, response);
        }
    }
}
}
