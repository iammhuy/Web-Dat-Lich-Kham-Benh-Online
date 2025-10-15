package app.controller;

import app.business.giaodich.PhuongThuc;
import app.business.giaodich.ThanhToan;
import app.business.giaodich.TrangThai;
import app.database.LichHenDAO;
import app.database.ThanhToanDB;
import com.vnpay.common.Config;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;
import javax.servlet.annotation.WebServlet;

@WebServlet("/ThanhToanServlet")
public class ThanhToanServlet extends HttpServlet {

    // --- Tạo thanh toán VNPAY ---
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.setContentType("text/html; charset=UTF-8");
            // ✅ 1. Lấy thông tin từ form
            int lichHenId = Integer.parseInt(request.getParameter("lichHenId"));
            BigDecimal soTien = new BigDecimal(request.getParameter("soTien"));

            // ✅ 2. Ghi tạm thanh toán
            ThanhToan thanhToan = new ThanhToan();
            thanhToan.setLichHenId(lichHenId);
            thanhToan.setSoTien(soTien);
            thanhToan.setPhuongThuc(PhuongThuc.VNPAY);
            thanhToan.setTrangThai(TrangThai.Pending);
            int thanhToanId = ThanhToanDB.createPendingPayment(thanhToan);

            if (thanhToanId == 0) {
                request.setAttribute("message", "Không thể khởi tạo thanh toán, vui lòng thử lại!");
                request.getRequestDispatcher("/payment_error.jsp").forward(request, response);
                return;
            }

            // ✅ 3. Tạo request VNPAY
            String vnp_Version = "2.1.0";
            String vnp_Command = "pay";
            String vnp_TmnCode = Config.vnp_TmnCode;
            String orderType = "other";
            String vnp_TxnRef = String.valueOf(thanhToanId);
            String vnp_IpAddr = request.getRemoteAddr();
            String vnp_OrderInfo = "Thanh toan lich hen ID: " + lichHenId;
            BigDecimal amountVNP = soTien.multiply(BigDecimal.valueOf(100));

            Map<String, String> vnp_Params = new HashMap<>();
            vnp_Params.put("vnp_Version", vnp_Version);
            vnp_Params.put("vnp_Command", vnp_Command);
            vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
            vnp_Params.put("vnp_Amount", amountVNP.toBigInteger().toString());
            vnp_Params.put("vnp_CurrCode", "VND");
            vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
            vnp_Params.put("vnp_OrderInfo", vnp_OrderInfo);
            vnp_Params.put("vnp_OrderType", orderType);
            vnp_Params.put("vnp_Locale", "vn");
            vnp_Params.put("vnp_ReturnUrl", Config.vnp_ReturnUrl);
            vnp_Params.put("vnp_IpAddr", vnp_IpAddr);

            // Thời gian tạo & hết hạn
            Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
            SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
            String vnp_CreateDate = formatter.format(cld.getTime());
            vnp_Params.put("vnp_CreateDate", vnp_CreateDate);
            cld.add(Calendar.MINUTE, 15);
            String vnp_ExpireDate = formatter.format(cld.getTime());
            vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);

            // ✅ 4. Tạo chuỗi hash + query
            List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
            Collections.sort(fieldNames);
            StringBuilder hashData = new StringBuilder();
            StringBuilder query = new StringBuilder();

            for (String fieldName : fieldNames) {
                String fieldValue = vnp_Params.get(fieldName);
                if (fieldValue != null && !fieldValue.isEmpty()) {
                    hashData.append(fieldName)
                            .append('=')
                            .append(URLEncoder.encode(fieldValue, StandardCharsets.UTF_8.toString()))
                            .append('&');
                    query.append(fieldName)
                            .append('=')
                            .append(URLEncoder.encode(fieldValue, StandardCharsets.UTF_8.toString()))
                            .append('&');
                }
            }
            String hashDataStr = hashData.substring(0, hashData.length() - 1);
            String queryUrl = query.substring(0, query.length() - 1);
            String vnp_SecureHash = Config.hmacSHA512(Config.vnp_HashSecret, hashDataStr);
            queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;
            String paymentUrl = Config.vnp_PayUrl + "?" + queryUrl;
            // ✅ 5. Redirect sang VNPAY sandbox
            response.sendRedirect(paymentUrl);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Có lỗi xảy ra khi tạo yêu cầu thanh toán.");
            request.getRequestDispatcher("/payment_error.jsp").forward(request, response);
        }
    }

    // --- Xử lý phản hồi ---
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            try {
                request.setCharacterEncoding("UTF-8");
                response.setCharacterEncoding("UTF-8");
                response.setContentType("text/html; charset=UTF-8");
                Map<String, String> fields = new HashMap<>();
                for (String key : request.getParameterMap().keySet()) {
                String value = request.getParameter(key);
                if (value != null && !value.isEmpty()) {
                   fields.put(key, value);
                        }
                }
                String vnp_SecureHash = request.getParameter("vnp_SecureHash");
                fields.remove("vnp_SecureHashType");
                fields.remove("vnp_SecureHash");
                // Hash lại dữ liệu nhận về
                 String signValue = Config.hmacSHA512(Config.vnp_HashSecret,Config.hashAllFields(fields));

                if (signValue.equals(vnp_SecureHash)) {
                    String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
                    int thanhToanId = Integer.parseInt(request.getParameter("vnp_TxnRef"));
                    ThanhToan thanhToan = ThanhToanDB.getById(thanhToanId);

                    if (thanhToan == null) {
                        request.setAttribute("message", "Không tìm thấy giao dịch thanh toán.");
                        request.getRequestDispatcher("/payment_error.jsp").forward(request, response);
                        return;
                    }
                    if ("00".equals(vnp_ResponseCode)) {
                        ThanhToanDB.updatePaymentStatus(thanhToanId, TrangThai.Success, request.getParameter("vnp_TransactionNo"));
                        LichHenDAO.xacNhanThanhToan(thanhToan.getLichHenId());
                        request.setAttribute("message", "Thanh toán thành công!");
                        request.getRequestDispatcher("/payment_success.jsp").forward(request, response);
                    } else {
                        ThanhToanDB.updatePaymentStatus(thanhToanId, TrangThai.Failed, request.getParameter("vnp_TransactionNo"));
                        request.setAttribute("message", "Thanh toán thất bại. Mã lỗi: " + vnp_ResponseCode);
                        request.getRequestDispatcher("/payment_error.jsp").forward(request, response);
                    }
                } else {
                    request.setAttribute("message", "Sai chữ ký!");
                    request.getRequestDispatcher("/payment_error.jsp").forward(request, response);
                }

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("message", "Lỗi xử lý kết quả thanh toán.");
                request.getRequestDispatcher("/payment_error.jsp").forward(request, response);
            }
    }
}
